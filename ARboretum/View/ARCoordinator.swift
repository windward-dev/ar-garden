//
//  ARCoordinator.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/7/23.
//

// Attribution: https://www.udemy.com/course/building-augmented-reality-apps-in-realitykit-arkit/learn/lecture/32531328#content
// A lot of the way I structured the ARView and Coordinator and saving/loading world maps was based on content from the above ARKit course

import Foundation
import RealityKit
import ARKit
import Combine
import SwiftUI

// Handles tap gestures and saving and loading AR world maps
class ARCoordinator {
    
    var arView: ARView?
    var mainScene: Experience.MainScene
    var cancellable: AnyCancellable?
    var vm: SeedViewModel
    var selectedPlant: PlantViewModel
    var appState: Binding<ARViewMain.UIState>
    @ObservedObject var gardenerManager = GardenerManager.shared
    
    init(vm: SeedViewModel, appState: Binding<ARViewMain.UIState>, selectedPlant: PlantViewModel) {
        self.vm = vm
        self.selectedPlant = selectedPlant
        self.mainScene = try! Experience.loadMainScene()
        self.appState = appState
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else {
            return
        }
        
        // Handle tap gesture when in seed planting stage
        // Looks for raycast collision with AR detected horizontal surfaces
        if appState.wrappedValue == .seedPlantUI {
            let location = recognizer.location(in: arView)
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let result = results.first {
                let plantableComponent: PlantableComponent
                print(vm.selectedSeed)
                switch vm.selectedSeed {
                case "Sunflower":
                    plantableComponent = SunflowerPlantableComponent()
                case "Lily":
                    plantableComponent = LilyPlantableComponent()
                case "Hydrangea":
                    plantableComponent = HydrangeaPlantableComponent()
                default:
                    plantableComponent = PlantableComponent()
                }
                
                let arAnchor = ARAnchor(name: plantableComponent.id, transform: result.worldTransform)
                
                let anchor = AnchorEntity(anchor: arAnchor)
                
                let plantableEntity = Entity()
                plantableEntity.components.set(plantableComponent)
                
                plantableComponent.loadModel(on: plantableEntity)
                
                arView.session.add(anchor: arAnchor)
                anchor.addChild(plantableEntity)
                arView.scene.addAnchor(anchor)
                
                print(vm.selectedSeed)
                gardenerManager.decrementSeedCount(seedType: vm.selectedSeed)
                gardenerManager.addPlant(plant: plantableComponent)
                appState.wrappedValue = .arMainUI
                AudioManager.shared.playSoundEffect(soundFile: "seedPlant")
            } else if appState.wrappedValue == .plantSelectUI{
                print(selectedPlant)
            }
        }
    
        
        // If there's a tap in the main AR UI, check if user tapped on a plant model and switch to the plant select menu
        if appState.wrappedValue == .arMainUI {
            
            let tapLocation = recognizer.location(in: arView)
            
            if let entity = arView.entity(at: tapLocation) as? ModelEntity {
                if let parentEntity = entity.anchor {
                    print("Tap detected on \(parentEntity.name)")
                    for childEntity in parentEntity.children {
                        // Do something with the childEntity
                        if let plantableComponent = childEntity.components[PlantableComponent.self] as? PlantableComponent {
                            // use the plantableComponent here
                            print("Plantable component found! Tap detected on \(plantableComponent.plantName)")
                            selectedPlant.selectedPlant = childEntity
                            print(selectedPlant.selectedPlant!)
                            appState.wrappedValue = .plantSelectUI
                        }
                    }
                }
            }
        }
        
        // If there's a tap in the plantSelectUI check if user tapped on a different plant and switch to that. tapping on nothing returns to main ar UI
        if appState.wrappedValue == .plantSelectUI {
            
            let tapLocation = recognizer.location(in: arView)
            
            if let entity = arView.entity(at: tapLocation) as? ModelEntity {
                if let parentEntity = entity.anchor {
                    print("Tap detected on \(parentEntity.name)")
                    for childEntity in parentEntity.children {
                        // Do something with the childEntity
                        if let plantableComponent = childEntity.components[PlantableComponent.self] as? PlantableComponent {
                            // use the plantableComponent here
                            print("Plantable component found! Tap detected on \(plantableComponent.plantName)")
                            selectedPlant.selectedPlant = childEntity
                            print(selectedPlant.selectedPlant!)
                            appState.wrappedValue = .plantSelectUI
                        }
                    }
                }
            } else {
                appState.wrappedValue = .arMainUI
            }
        }
    }
    
    // Loads the world map and reconfigures all of the plantable components so they are matched
    // to their original ARAnchor objects
    func loadWorldMap() {
        
        guard let arView = arView else {
            return
        }
        
        let userDefaults = UserDefaults.standard
        
        if let data = userDefaults.data(forKey: "worldMap") {
            
            print("LOADING WORLD MAP \(data)")
            
            guard let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                return
            }
            
            // Loop through ARAnchors and re-add plantable components
            for anchor in worldMap.anchors {
                print(anchor.name ?? "anchor has no name")
                let anchorEntity = AnchorEntity(anchor: anchor)
                
                let plantableEntity = Entity()
                print(GardenerManager.shared.getPlantList())
                // Find matching plantable component and add it back in.
                for plantableComponent in GardenerManager.shared.getPlantList() {
                    print("Anchor name: \(anchor.name ?? "noname")")
                    print("Plant Name:  \(plantableComponent.id)")
                    if plantableComponent.id == anchor.name {
                        print("Found anchors matching plant component.")
                        plantableEntity.components.set(plantableComponent)
                        plantableComponent.loadModel(on: plantableEntity)
                        break
                    }
                }
                
                anchorEntity.addChild(plantableEntity)
                arView.scene.addAnchor(anchorEntity)
            }
            
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.initialWorldMap = worldMap
            configuration.planeDetection = .horizontal
            
            arView.session.run(configuration)
        }
    }
    
    
    // Saves all of the anchors and their world positions in the scanned world
    // Only saves ARAnchor objects and removes all child entities.
    // Seperately save plantable components so we can reconnect to ARAnchors in load
    func saveWorldMap() {
        
        print("SAVING WORLD MAP AND ANCHORS")
        guard let arView = arView else {
            print("ARView not found while saving. Save failed.")
            return
        }
        
        arView.session.getCurrentWorldMap { worldMap, error in
           
            if let error = error {
                print(error)
                return
            }
            
            if let worldMap = worldMap {
                
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true) else {
                    return
                }
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: "worldMap")
                userDefaults.synchronize()
                
            }
        }
        
    }
}
