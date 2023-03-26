//
//  LilyPlantableComponent.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import Foundation

class LilyPlantableComponent: PlantableComponent {
    override var finalModel: String {
        get {
            return "Lily"

        }
        set {
            super.finalModel = "Lily"
        }
    }
    
    override var sellPrice: Int {
        get {
            return 17

        }
        set {
            super.sellPrice = 17
        }
    }
    
    override var stageLength: TimeInterval {
        get {
            return 60

        }
        set {
            super.stageLength = 60
        }
    }
    
    override var plantName: String {
        get {
            return "Lily"

        }
        set {
            super.plantName = "Lily"
        }
    }
}
