//
//  Gardener.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/1/23.
//

import Foundation

class Gardener: ObservableObject, Codable {
    var money: Int
    var seedPouch: [String: Int]
    var currentPlants: [PlantableComponent]
    
    init() {
        self.money = 20
        self.seedPouch = ["Generic": 5, "Sunflower": 2, "Lily": 2, "Hydrangea": 1]
        self.currentPlants = []
    }
    
}
