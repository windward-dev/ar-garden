//
//  PlantSelectUI.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/8/23.
//

import SwiftUI

struct PlantSelectUI: View {
    @ObservedObject var selectedPlant: PlantViewModel
    @ObservedObject var gardenerManager = GardenerManager.shared
    @Binding var appState: ARViewMain.UIState
    @State private var currentStage: Int
    
    init(selectedPlant: PlantViewModel, appState: Binding<ARViewMain.UIState>, currentStage: Int) {
            self.selectedPlant = selectedPlant
            self._appState = appState
            self._currentStage = State(initialValue: currentStage)
        }
    
    var body: some View {
        
        let plantableComponent = selectedPlant.selectedPlant?.components[PlantableComponent.self] as? PlantableComponent
        
        let currentStage = State(initialValue: selectedPlant.selectedPlant?.components[PlantableComponent.self]?.currentStage ?? 0)
        
        VStack {
            VStack {
                Text(plantableComponent?.plantName ?? "Plant not found")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextSwitch"))
                
                if let stage = plantableComponent?.currentStage {
                    Text("Stage: \(stage)")
                        .font(.headline)
                        .foregroundColor(Color("TextSwitch"))
                } else {
                    Text("Stage: Unknown")
                        .font(.headline)
                        .foregroundColor(Color("TextSwitch"))
                }
                
                if plantableComponent?.isWatered == true {
                    Text("Time till next waterable: \((plantableComponent?.lastWatered!)! + plantableComponent!.stageLength)")
                        .font(.caption)
                        .foregroundColor(Color("TextSwitch"))
                        .padding(.top, 5)
                } else if plantableComponent?.currentStage ?? 3 < 3 {
                    Text("Time till next waterable: NOW")
                        .font(.caption)
                        .foregroundColor(Color("TextSwitch"))
                        .padding(.top, 5)
                } else {
                    Text("")
                }
            }
            .padding()
            .background(Color("ThemeBG"))
            .cornerRadius(10.0)
            .padding(.horizontal)
            
            Button(action: {
                // Handle back button press
                appState = .arMainUI
            }) {
                Image(systemName: "arrow.left")
                    .font(.title)
            }
            .padding()
            .foregroundColor(Color("TextSwitch"))
            .background(Color("ThemeBG"))
            .cornerRadius(10.0)

            Spacer()
            
            HStack {
                if plantableComponent?.isWatered == false && plantableComponent?.currentStage ?? 3 < 3 {
                    Button(action: {
                        // Handle water button press
                        plantableComponent?.waterPlant()
                        appState = .arMainUI
                        appState = .plantSelectUI
                        AudioManager.shared.playSoundEffect(soundFile: "water")
                    }) {
                        Image(systemName: "drop.circle")
                            .font(.title)
                        Text("Water")
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8.0)
                }
                
                if plantableComponent?.currentStage == 3 {
                    Button(action: {
                        // Handle sell button press
                        // Add sell price to gardener's money
                        gardenerManager.addMoney(money: plantableComponent?.sellPrice ?? 0)
                        gardenerManager.removePlant(id: plantableComponent!.id)
                        // Remove anchor entity
                        selectedPlant.selectedPlant?.anchor?.removeFromParent()
                        // Revert to AR Main UI
                        appState = .arMainUI
                        AudioManager.shared.playSoundEffect(soundFile: "sold")
                    }) {
                        Image(systemName: "dollarsign.circle")
                            .font(.title)
                        Text("Sell")
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8.0)
                }
                Button(action: {
                    // Handle sell button press
                    gardenerManager.removePlant(id: plantableComponent!.id)
                    // Remove ARAnchor to delete the entire object
                    selectedPlant.selectedPlant?.anchor?.removeFromParent()
                    // Revert to AR Main UI
                    appState = .arMainUI
                }) {
                    Image(systemName: "trash.circle")
                        .font(.title)
                    Text("Trash")
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(8.0)
            }
        } .onChange(of: currentStage.wrappedValue) { value in
            // Reset data
            appState = .arMainUI
            appState = .plantSelectUI
        }
    }
}

struct PlantSelectUI_Previews: PreviewProvider {
    static var previews: some View {
        PlantSelectUI(selectedPlant: PlantViewModel(), appState: .constant(.arMainUI), currentStage: 1)
    }
}
