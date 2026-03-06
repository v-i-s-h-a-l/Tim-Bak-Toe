import Foundation

struct Move: Equatable, Sendable {
    let pieceId: UUID
    let from: BoardPosition?
    let to: BoardPosition
}
