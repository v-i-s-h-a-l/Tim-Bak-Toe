import Foundation

struct WinChecker: Sendable {
    static let winningLines: [Set<BoardPosition>] = [
        // Rows
        Set([BoardPosition(row: 0, column: 0), BoardPosition(row: 0, column: 1), BoardPosition(row: 0, column: 2)]),
        Set([BoardPosition(row: 1, column: 0), BoardPosition(row: 1, column: 1), BoardPosition(row: 1, column: 2)]),
        Set([BoardPosition(row: 2, column: 0), BoardPosition(row: 2, column: 1), BoardPosition(row: 2, column: 2)]),
        // Columns
        Set([BoardPosition(row: 0, column: 0), BoardPosition(row: 1, column: 0), BoardPosition(row: 2, column: 0)]),
        Set([BoardPosition(row: 0, column: 1), BoardPosition(row: 1, column: 1), BoardPosition(row: 2, column: 1)]),
        Set([BoardPosition(row: 0, column: 2), BoardPosition(row: 1, column: 2), BoardPosition(row: 2, column: 2)]),
        // Diagonals
        Set([BoardPosition(row: 0, column: 0), BoardPosition(row: 1, column: 1), BoardPosition(row: 2, column: 2)]),
        Set([BoardPosition(row: 2, column: 0), BoardPosition(row: 1, column: 1), BoardPosition(row: 0, column: 2)]),
    ]

    static func checkWin(positions: [BoardPosition]) -> Bool {
        guard positions.count == 3 else { return false }
        let positionSet = Set(positions)
        return winningLines.contains(positionSet)
    }

    static func winningLine(for positions: [BoardPosition]) -> Set<BoardPosition>? {
        guard positions.count == 3 else { return nil }
        let positionSet = Set(positions)
        return winningLines.first(where: { $0 == positionSet })
    }
}
