//
//  GardenerManager.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/7/23.
//

import Foundation

// Singleton to make accessing user data easier throughout the app since there can be only one user profile per device for now
class GardenerManager: ObservableObject {
    static let shared = GardenerManager()
    private var gardener: Gardener
    
    private init() {
        self.gardener = Gardener()
        self.loadGardener()
    }
    
    func saveGardener() {
        let encoder = JSONEncoder()
        if let encodedGardener = try? encoder.encode(gardener) {
            UserDefaults.standard.set(encodedGardener, forKey: "gardener")
            print("Gardener data succesfully SAVED")
        }
    }
    
    func loadGardener() {
        if let savedGardener = UserDefaults.standard.data(forKey: "gardener") {
            let decoder = JSONDecoder()
            if let loadedGardener = try? decoder.decode(Gardener.self, from: savedGardener) {
                print("Gardener profile found and loaded!")
                gardener = loadedGardener
            }
        } else {
            print("User profile not loaded. Creating new one!")
        }
    }
    
    func addMoney(money: Int) {
        print("Money prior to selling: $\(gardener.money)")
        gardener.money += money
        print("Money after to selling: $\(gardener.money)")
    }
    
    func removeMoney(money: Int) {
        print("Money prior to buying: $\(gardener.money)")
        gardener.money -= money
        print("Money after to buying: $\(gardener.money)")
    }
    
    func getMoney() -> Int {
        return gardener.money
    }
    
    func decrementSeedCount(seedType: String) {
        print(gardener.seedPouch)
        print(seedType)
        gardener.seedPouch[seedType]? -= 1
        print(gardener.seedPouch)
    }
    
    func addSeed(seedType: String) {
        print("Adding purchased seed!")
        if let currentCount = gardener.seedPouch[seedType] {
            gardener.seedPouch[seedType] = currentCount + 1
        } else {
            gardener.seedPouch[seedType] = 1
        }
    }
    
    func addPlant(plant: PlantableComponent) {
        print("Adding plant")
        gardener.currentPlants.append(plant)
        print(self.getPlantList())
    }
    
    func updatePlant(plant: PlantableComponent) {
        print("Adding plant")
        // Find the index of the plant with the matching ID
        if let index = gardener.currentPlants.firstIndex(where: { $0.id == plant.id }) {
            
            // Replace the old plant with the updated plant
            gardener.currentPlants[index] = plant
        }
        print(self.getPlantList())
    }
    
    func removePlant(id: String) {
        print("Removing plant")
        gardener.currentPlants.removeAll { $0.id == id }
    }
    
    func getGardener() -> Gardener {
        return gardener
    }
    
    func getPlantList() -> [PlantableComponent] {
        print("Grabbing plant list")
        return gardener.currentPlants
    }
}
