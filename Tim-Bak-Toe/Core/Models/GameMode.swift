import Foundation

enum AIDifficulty: String, CaseIterable, Sendable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

enum GameMode: Equatable, Sendable {
    case localMultiplayer
    case vsAI(AIDifficulty)
    case onlineMultiplayer

    static func == (lhs: GameMode, rhs: GameMode) -> Bool {
        switch (lhs, rhs) {
        case (.localMultiplayer, .localMultiplayer): return true
        case (.vsAI(let a), .vsAI(let b)): return a == b
        case (.onlineMultiplayer, .onlineMultiplayer): return true
        default: return false
        }
    }
}
