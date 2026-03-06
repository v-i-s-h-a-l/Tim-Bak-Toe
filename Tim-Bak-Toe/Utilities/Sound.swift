import AVFoundation
import Foundation

enum Sound: Int {
    case place = 1305
    case pop = 1306
    case tap = 1103
    case win = 1334

    func play() {
        let soundOn = UserDefaults.standard.object(forKey: "soundOn") as? Bool ?? true
        guard soundOn else { return }
        DispatchQueue.global().async {
            AudioServicesPlaySystemSound(SystemSoundID(self.rawValue))
        }
    }
}
