import Foundation

struct GameBoard: Sendable {
    private var cells: [BoardPosition: UUID] = [:]

    func pieceId(at position: BoardPosition) -> UUID? {
        cells[position]
    }

    func isEmpty(at position: BoardPosition) -> Bool {
        cells[position] == nil
    }

    mutating func place(pieceId: UUID, at position: BoardPosition) {
        cells[position] = pieceId
    }

    mutating func remove(pieceId: UUID) {
        cells = cells.filter { $0.value != pieceId }
    }

    func position(of pieceId: UUID) -> BoardPosition? {
        cells.first(where: { $0.value == pieceId })?.key
    }

    func positions(for pieceIds: [UUID]) -> [BoardPosition] {
        pieceIds.compactMap { position(of: $0) }
    }

    var occupiedPositions: [BoardPosition: UUID] {
        cells
    }

    mutating func reset() {
        cells.removeAll()
    }
}
