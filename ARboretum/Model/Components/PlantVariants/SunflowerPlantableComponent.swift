//
//  SunflowerPlantableComponent.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import Foundation

class SunflowerPlantableComponent: PlantableComponent {
    override var finalModel: String {
        get {
            return "Sunflower"

        }
        set {
            super.finalModel = "Sunflower"
        }
    }
    
    override var sellPrice: Int {
        get {
            return 10

        }
        set {
            super.sellPrice = 10
        }
    }
    
    override var stageLength: TimeInterval {
        get {
            return 30

        }
        set {
            super.stageLength = 30
        }
    }
    
    override var plantName: String {
        get {
            return "Sunflower"

        }
        set {
            super.plantName = "Sunflower"
        }
    }
}
