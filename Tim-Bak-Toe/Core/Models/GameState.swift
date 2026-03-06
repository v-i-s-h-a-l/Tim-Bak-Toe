import Foundation

enum GameState: Equatable, Sendable {
    case waitingToStart
    case playing(turn: Player)
    case won(Player)
    case draw

    var isGameOver: Bool {
        switch self {
        case .won, .draw: return true
        default: return false
        }
    }

    var currentTurn: Player? {
        switch self {
        case .playing(let turn): return turn
        default: return nil
        }
    }

    var winner: Player? {
        switch self {
        case .won(let player): return player
        default: return nil
        }
    }
}
