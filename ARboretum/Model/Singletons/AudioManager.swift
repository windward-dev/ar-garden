//
//  AudioManager.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import Foundation
import AVFAudio

// Singleton to make accessing user data easier throughout the app since there can be only one user profile per device for now
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    var audioOn: Bool = true
    private var audioPlayer: AVAudioPlayer?
        
    func playSoundEffect(soundFile: String) {
        if audioOn{
            guard let url = Bundle.main.url(forResource: soundFile, withExtension: "wav") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func toggleAudio(){
        audioOn = !audioOn
    }
}
