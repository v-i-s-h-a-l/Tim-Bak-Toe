import Foundation

struct PlayerPiece: Identifiable, Sendable {
    let id = UUID()
    let owner: Player
    var boardPosition: BoardPosition?

    var isOnBoard: Bool { boardPosition != nil }
}
