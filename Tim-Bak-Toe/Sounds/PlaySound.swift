//
//  PlaySound.swift
//  XO3
//
//  Created by Vishal Singh on 08/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import AVFoundation
import Foundation

enum Sound: Int {

    case place = 1305
    case pop = 1306
    case tap = 1103
    case win = 1334
    
    func play() {
        guard GameSettings.user.soundOn else { return }
        DispatchQueue.global().async {
            AudioServicesPlaySystemSound(SystemSoundID(self.rawValue))
        }
    }
}
