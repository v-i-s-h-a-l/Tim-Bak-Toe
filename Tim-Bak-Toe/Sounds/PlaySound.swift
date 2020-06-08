//
//  PlaySound.swift
//  XO3
//
//  Created by Vishal Singh on 08/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import AVFoundation
import Foundation

enum Sound: String {

    case place, pop, tap, win
    
    var fileExtension: String {
        return "wav"
    }
    
    var fileURL: URL {
        return Bundle.main.url(forResource: self.rawValue, withExtension: self.fileExtension)!
    }

    var volume: Float {
        return 1.0
    }

    func play() {
        SoundManager.shared.play(self)
    }
}

private final class SoundManager {

    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print(error)
        }
    }

    func play(_ sound: Sound) {
        audioPlayer?.stop()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound.fileURL)
            audioPlayer?.volume = sound.volume
            audioPlayer?.play()
        } catch {
            print("couldn't play sound: \(sound.rawValue)")
            print(error)
        }
    }
}
