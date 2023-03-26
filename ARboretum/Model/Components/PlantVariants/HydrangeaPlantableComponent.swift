//
//  HydrangeaPlantableComponent.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import Foundation

class HydrangeaPlantableComponent: PlantableComponent {
    override var finalModel: String {
        get {
            return "Hydrangea"

        }
        set {
            super.finalModel = "Hydrangea"
        }
    }
    
    override var sellPrice: Int {
        get {
            return 30

        }
        set {
            super.sellPrice = 30
        }
    }
    
    override var stageLength: TimeInterval {
        get {
            return 300

        }
        set {
            super.stageLength = 300
        }
    }
    
    override var plantName: String {
        get {
            return "Hydrangea"

        }
        set {
            super.plantName = "Hydrangea"
        }
    }
}
