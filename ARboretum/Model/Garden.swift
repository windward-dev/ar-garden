//
//  Arboretum.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/1/23.
//

import Foundation

// Class that will eventually be used to allow for multiple gardens in different locations
class Garden {
    var plantables: [PlantableComponent]
    
    init(plantables: [PlantableComponent]) {
        self.plantables = plantables
    }
    
    func addPlaceable(_ plantable: PlantableComponent) {
        plantables.append(plantable)
    }
}
