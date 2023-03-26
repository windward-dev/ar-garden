//
//  GrowthSystem.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/7/23.
//

import Foundation
import RealityKit

// System that finds all entities with a PlantableComponent and checks if they've been in a watered state long enough to grow
class GrowthSystem : System {
    // Initializer is required. Use an empty implementation if there's no setup needed.
    required init(scene: Scene) { }

    // Define a query to return all entities with a PlantableComponent.
    private static let growthQuery = EntityQuery(where: .has(PlantableComponent.self))

    // Every frame this is called on all entities
    func update(context: SceneUpdateContext) {
        
        // RealityKit automatically calls this every frame for every scene.
        context.scene.performQuery(Self.growthQuery).forEach { entity in
            // Make per-frame changes to each entity here
            guard let plantable: PlantableComponent = entity.components[PlantableComponent.self] as? PlantableComponent else { return }
            
            // Calculate the time since last watering
            guard let lastWatered = plantable.lastWatered else { return }
            let timeSinceWatered = -lastWatered.timeIntervalSinceNow
            
            // Check if it's time to advance to the next stage
            if plantable.isWatered && timeSinceWatered > plantable.stageLength {
                plantable.advanceToNextStage(on: entity)
                GardenerManager.shared.updatePlant(plant: plantable)
            }
        }
    }
}
