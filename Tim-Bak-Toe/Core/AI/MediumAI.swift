import Foundation

struct MediumAI: AIStrategy {
    func selectMove(engine: GameEngine, player: Player) async -> Move? {
        let moves = engine.validMoves(for: player)
        guard !moves.isEmpty else { return nil }

        // Try to win
        for move in moves {
            var testEngine = engine
            if testEngine.executeMove(move), case .won = testEngine.state {
                return move
            }
        }

        // Try to block opponent win
        let opponent = player.opponent
        let opponentMoves = engine.validMoves(for: opponent)
        for opponentMove in opponentMoves {
            var testEngine = engine
            if testEngine.executeMove(opponentMove), case .won = testEngine.state {
                // Block by placing at that position
                if let blockingMove = moves.first(where: { $0.to == opponentMove.to }) {
                    return blockingMove
                }
            }
        }

        // Prefer center
        let center = BoardPosition(row: 1, column: 1)
        if let centerMove = moves.first(where: { $0.to == center }) {
            return centerMove
        }

        // Prefer corners
        let corners = [
            BoardPosition(row: 0, column: 0),
            BoardPosition(row: 0, column: 2),
            BoardPosition(row: 2, column: 0),
            BoardPosition(row: 2, column: 2),
        ]
        let cornerMoves = moves.filter { corners.contains($0.to) }
        if let cornerMove = cornerMoves.randomElement() {
            return cornerMove
        }

        return moves.randomElement()
    }
}
