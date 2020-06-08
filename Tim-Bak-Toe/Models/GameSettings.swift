//
//  GameSettings.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 24/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation

//enum GameDifficulty: Int, Codable {
//    
//    case slow
//    case medium
//    case fast
//    
//    var pauseTime: Double {
//        switch self {
//        case .slow: return 5.0
//        case .medium: return 4.5
//        case .fast: return 3.0
//        }
//    }
//    
//    var difficultyDescription: String {
//        switch self {
//        case .slow: return "🚶‍♀️🚶‍♂️"
//        case .medium: return "🏃‍♀️🏃‍♂️"
//        case .fast: return "⚡️"
//        }
//    }
//}

final class GameSettings: ObservableObject {
    
    enum SettingsType: String {
        case factory, user
    }

    static var user: GameSettings = GameSettings(with: .user)
    private static var factory: GameSettings = GameSettings()
    
    @Published var soundOn: Bool = true
    @Published var timerDuration: Double = 5.0

    public let timerStride = 1.0

    private var cancellables = Set<AnyCancellable>()
    private init() {}
    
    private init(with type: SettingsType) {
        // default settings that come bundled with app
        let factorySettings = GameSettings()

        // taking soundOff because by default user defaults will return false
        let savedSoundOn = !UserDefaults.standard.bool(forKey: "soundOff")
        let savedTimerDuration = UserDefaults.standard.double(forKey: "timerDuration")

        factorySettings.soundOn = savedSoundOn
        factorySettings.timerDuration = savedTimerDuration == 0 ? factorySettings.timerDuration : timerDuration

        self.soundOn = factorySettings.soundOn
        self.timerDuration = factorySettings.timerDuration

        self.$soundOn.sink { newValue in
            UserDefaults.standard.set(!newValue, forKey: "soundOff")
        }
        .store(in: &cancellables)

        self.$timerDuration.sink { newValue in
            UserDefaults.standard.set(newValue, forKey: "timerDuration")
        }
        .store(in: &cancellables)
    }
}
