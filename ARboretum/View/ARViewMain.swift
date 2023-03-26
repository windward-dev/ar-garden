//
//  ARViewMain.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/1/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewMain : View {
    
    enum UIState {
        case arMainUI
        case seedPlantUI
        case plantSelectUI
    }
    
    @EnvironmentObject var appState: AppState
    
    @StateObject private var vm = SeedViewModel()
    @StateObject private var selectedPlant = PlantViewModel()
    @StateObject private var saveModel = SaveModel()

    @ObservedObject var gardenerManager = GardenerManager.shared
    @State private var uiState: UIState = .arMainUI
    @State private var showSeedSheet = false
    @State private var showStoreSheet = false
    @State private var showSettingsSheet = false
    @State private var showingInfoAlert = false
    @State private var currentSeedType = "Default"
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(vm: vm, selectedPlant: selectedPlant, saveModel: saveModel, appState: $uiState).edgesIgnoringSafeArea(.all)
            
            // Select the proper UI overlay onn ARView depending on app state
            switch uiState {
            case .arMainUI:
                // Show buttons for state A
                VStack {
                    HStack{
                        Spacer()
                        Button(action: {
                            showingInfoAlert = true
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(Color("ThemeWhite"))
                                .padding(.trailing, 20)
                        }
                        
                    }
                    Spacer()
                    HStack(spacing: 30.0) {
                        Button(action: {
                            showSeedSheet = true
                            AudioManager.shared.playSoundEffect(soundFile: "seedPouch")
                        }) {
                            VStack{
                                Text("Seeds")
                                Image(systemName: "leaf.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.white)
                            }
                        }
                        .sheet(isPresented: $showSeedSheet) {
                            SeedPouchView(vm: vm, appState: $uiState)
                                .environmentObject(gardenerManager.getGardener())
                        }
                        
                        Button(action: {
                            showStoreSheet = true
                            AudioManager.shared.playSoundEffect(soundFile: "shop")
                        }) {
                            VStack{
                                Text("Store")
                                Image(systemName: "dollarsign.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.white)
                            }

                        }
                        .sheet(isPresented: $showStoreSheet) {
                            StoreView(appState: $uiState)
                                .environmentObject(gardenerManager.getGardener())
                        }
                        
                        Button(action: {
                            showSettingsSheet = true
                        }) {
                            VStack{
                                Text("Settings")
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.white)
                            }

                        }
                        .sheet(isPresented: $showSettingsSheet) {
                            SettingsView(appState: $uiState)
                                .environmentObject(gardenerManager.getGardener())
                        }
                    }
                    .accentColor(.white)
                    .background(Color.clear)
                    .padding(.bottom, 16.0)
                } .alert(isPresented: $showingInfoAlert) {
                    Alert(
                        title: Text("Instructions"),
                        message: Text("Find a well lit place to map your area. Move your camera around to get multiple angles to improve the ability of the app to replant flowers when you log back in.\n\nSeeds Menu: Select the seeds icon on the bottom to see a list of the different seed types and quantity of each you have.\n\nTap on an existing plant to select it for planting. Once planted, tapping on that plant will bring up its menu allowing you to water it if it's dry, sell it if it's fully grown, or trash it if you just want to get rid of it for no money.\n\nThe store allows you to buy more seed types to plant if you have sufficient funds. Enjoy! "),
                        dismissButton: .default(Text("Got it!"))
                    )
                }
                
                
            case .seedPlantUI:
                // Show text label and button for state B
                VStack {
                    Text("Plant \(vm.selectedSeed) seed by tapping on a horizontal surface!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(.clear)
                
                
            case .plantSelectUI:
                PlantSelectUI(selectedPlant: selectedPlant, appState: $uiState, currentStage: selectedPlant.selectedPlant?.components[PlantableComponent.self]?.currentStage ?? 0)
            }
        }
        .onAppear {
            // Set initial app state here
            uiState = .arMainUI
            appState.save(saveModel: saveModel)
        }
        .onDisappear {
            saveModel.onSave()
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    let vm: SeedViewModel
    let selectedPlant: PlantViewModel
    let saveModel: SaveModel
    let appState: Binding<ARViewMain.UIState>
    
    func makeUIView(context: Context) -> ARView {
        GrowthSystem.registerSystem()
        
        let arView = ARView(frame: .zero)
        
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(ARCoordinator.tapped)))
        context.coordinator.arView = arView
        
        saveModel.onSave = {
            context.coordinator.saveWorldMap()
        }
        
        // Attempt to load a prior loadmap
        context.coordinator.loadWorldMap()
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(vm: vm, appState: appState, selectedPlant: selectedPlant)
    }
    
}

#if DEBUG
struct ARViewMain_Previews : PreviewProvider {
    static var previews: some View {
        ARViewMain()
    }
}
#endif
