//
//  Placeable.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/1/23.
//

import Foundation
import RealityKit

// Not used yet, but will be for decorative only items
class PlaceableComponent: Component, Identifiable {
    var id: UUID = UUID()
    var arboretum: Garden?
    var position: SIMD3<Float>
    
    init(position: SIMD3<Float>, arboretum: Garden?) {
        self.position = position
        self.arboretum = arboretum
    }
}
