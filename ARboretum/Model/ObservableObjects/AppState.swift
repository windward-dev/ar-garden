//
//  AppState.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import Foundation
import UIKit

// This class is to allow me to more easily auto-save game data throughout the app if the app is terminated or moved to the background at all
// Attribution: https://stackoverflow.com/questions/63753745/how-can-i-use-a-method-without-any-page-transition-or-any-reboot-app/63765784#63765784
class AppState: ObservableObject {
    @Published var isActive = true

    var observers = [NSObjectProtocol]()

    init() {
        
    }
    
    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
    
    func save(saveModel: SaveModel) {
        // Subscribe to app state changes
        observers.append(NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            print("APP ENTERING BACKGROUND")
            saveModel.onSave()
        })
        observers.append(NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            print("APP TERMINATING")
            saveModel.onSave()
        })
    }
}
