import Foundation

struct BoardPosition: Hashable, Sendable, CustomStringConvertible {
    let row: Int
    let column: Int

    var description: String { "\(row),\(column)" }

    static let allPositions: [BoardPosition] = {
        var positions = [BoardPosition]()
        for row in 0...2 {
            for column in 0...2 {
                positions.append(BoardPosition(row: row, column: column))
            }
        }
        return positions
    }()

    var index: Int { row * 3 + column }
}
