//
//  SoundManager.swift
//  NextSounds
//
//  Created by David Oliver Barreto Rodríguez on 20/11/20.
//

import Foundation
import AVFoundation


class SoundManager {
    
    static var audioPlayer: AVAudioPlayer!
    
    static func playSound(_ soundFileName: String) {
        
        if let path = Bundle.main.path(forResource: soundFileName, ofType: "mp3"){
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                guard let player = audioPlayer else { return }
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("The file doesn not exist at path")
        }
    }
}
