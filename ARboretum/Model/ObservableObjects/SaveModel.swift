//
//  SaveModel.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/8/23.
//

import Foundation

// To help initiates game state saves
class SaveModel: ObservableObject {
    var onSave: () -> Void = { }
    @Published var isSaved: Bool = false
}
