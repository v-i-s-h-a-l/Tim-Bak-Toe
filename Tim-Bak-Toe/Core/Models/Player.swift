import Foundation

enum Player: String, Codable, Sendable, CaseIterable {
    case x
    case o

    var opponent: Player {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }
}
