//
//  PlantableComponent.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/7/23.
//

import Foundation
import RealityKit
import Combine
import SwiftUI

// The parent component of plantable items, storing all variables needed to maintain state
class PlantableComponent: Component, Codable {
    let id: String
    var currentStage: Int
    var totalStages: Int
    open var stageLength: TimeInterval
    var lastWatered: Date?
    var isWatered: Bool
    var seedModel: String
    var growthModel: String
    open var finalModel: String
    var currentModel: String
    open var plantName: String
    open var sellPrice: Int
    
    init() {
        self.id = "\(UUID())"
        self.currentStage = 1
        self.totalStages = 3
        self.stageLength = 10
        self.lastWatered = Date()
        self.isWatered = false
        self.seedModel = "seed_stage"
        self.growthModel = "growth_stage"
        self.finalModel = "Generic"
        self.currentModel = seedModel
        self.plantName = "Generic Flower"
        self.sellPrice = 2
    }
    
    // Swaps out the model when next stage reached
    func advanceToNextStage(on entity: Entity) {
        print("Plant \(self.id) is growing to stage \(self.currentStage + 1)!")

        guard let modelEntity = entity.parent?.findEntity(named: "/") as? Entity else {
            print("Model entity not found")
            return
        }
        
        // Remove the previous 3D model component
        entity.parent?.removeChild(modelEntity)
        
        // Increment the current stage
        self.currentStage += 1
        self.isWatered = false
        
        switch self.currentStage {
        case 2:
            currentModel = self.growthModel
        case 3:
            currentModel = self.finalModel
        default:
            currentModel = self.growthModel
        }

        self.loadModel(on: entity)
        AudioManager.shared.playSoundEffect(soundFile: "seedPlant")
    }
    
    // Begins countdown to next stage
    func waterPlant() {
        print("Plant \(self.id) was watered.")
        isWatered = true
        lastWatered = Date()
    }
    
    // Async loading of the appropriate 3d model
    func loadModel(on entity: Entity) {
        print("Loading new plant model")
        var cancellable: AnyCancellable?

        // Async load of the model
        cancellable = ModelEntity.loadAsync(named: currentModel)
            .sink { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    print("Unable to load model \(error)")
                }
                
                cancellable?.cancel()
                
            } receiveValue: { modelEntity in
                modelEntity.generateCollisionShapes(recursive: true)
                entity.parent!.addChild(modelEntity)
            }
    }
}

extension Entity {
    var plantable: PlantableComponent? {
        return self.components[PlantableComponent.self]
    }
}
