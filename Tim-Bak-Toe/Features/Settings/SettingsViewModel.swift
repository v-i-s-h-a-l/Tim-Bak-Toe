import SwiftUI
import Observation

@MainActor @Observable
final class SettingsViewModel {
    var soundOn: Bool {
        didSet { UserDefaults.standard.set(soundOn, forKey: "soundOn") }
    }

    var timerDuration: Double {
        didSet { UserDefaults.standard.set(timerDuration, forKey: "timerDuration") }
    }

    var colorSchemeSetting: Int {
        didSet {
            UserDefaults.standard.set(colorSchemeSetting, forKey: "colorScheme")
        }
    }

    var appTheme: AppTheme {
        didSet { UserDefaults.standard.set(appTheme.rawValue, forKey: "appTheme") }
    }

    var preferredColorScheme: ColorScheme? {
        switch colorSchemeSetting {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }

    init() {
        let storedSoundOn = UserDefaults.standard.object(forKey: "soundOn") as? Bool ?? true
        let storedDuration = UserDefaults.standard.double(forKey: "timerDuration")
        let storedColorScheme = UserDefaults.standard.integer(forKey: "colorScheme")
        let storedThemeRaw = UserDefaults.standard.string(forKey: "appTheme")
        let storedTheme = storedThemeRaw.flatMap { AppTheme(rawValue: $0) } ?? AppTheme.defaultTheme

        self.soundOn = storedSoundOn
        self.timerDuration = storedDuration == 0 ? 5.0 : storedDuration
        self.colorSchemeSetting = storedColorScheme
        self.appTheme = storedTheme
    }
}
