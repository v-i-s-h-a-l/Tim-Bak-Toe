import Foundation

struct EasyAI: AIStrategy {
    func selectMove(engine: GameEngine, player: Player) async -> Move? {
        let moves = engine.validMoves(for: player)
        guard !moves.isEmpty else { return nil }

        // Force-place all pieces before relocating, unless a move wins immediately
        let placements = moves.filter { $0.from == nil }
        let hasUnplacedPieces = !placements.isEmpty

        // Always take the win
        for move in moves {
            var testEngine = engine
            if testEngine.executeMove(move), case .won = testEngine.state {
                // Only allow relocation wins if all pieces are placed
                if !hasUnplacedPieces || move.from == nil {
                    return move
                }
            }
        }

        let candidates = hasUnplacedPieces ? placements : moves

        // Try to block opponent's two-in-a-row
        if let blockingMove = findBlockingMove(engine: engine, player: player, moves: candidates) {
            return blockingMove
        }

        return candidates.randomElement()
    }

    private func findBlockingMove(engine: GameEngine, player: Player, moves: [Move]) -> Move? {
        let opponentPieceIds = engine.pieces(for: player.opponent).map(\.id)
        let opponentPositions = Set(engine.board.positions(for: opponentPieceIds))

        for line in WinChecker.winningLines {
            let opponentInLine = line.filter { opponentPositions.contains($0) }
            let emptyInLine = line.filter { engine.board.isEmpty(at: $0) }
            if opponentInLine.count == 2 && emptyInLine.count == 1 {
                if let blockingMove = moves.first(where: { $0.to == emptyInLine.first! }) {
                    return blockingMove
                }
            }
        }
        return nil
    }
}
