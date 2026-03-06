import Foundation

struct HardAI: AIStrategy {
    func selectMove(engine: GameEngine, player: Player) async -> Move? {
        let moves = engine.validMoves(for: player)
        guard !moves.isEmpty else { return nil }

        var bestScore = Int.min
        var bestMove = moves[0]

        for move in moves {
            var testEngine = engine
            guard testEngine.executeMove(move) else { continue }
            let score = minimax(engine: testEngine, depth: 8, isMaximizing: false, aiPlayer: player, alpha: Int.min, beta: Int.max)
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }

        return bestMove
    }

    private func minimax(engine: GameEngine, depth: Int, isMaximizing: Bool, aiPlayer: Player, alpha: Int, beta: Int) -> Int {
        if case .won(let winner) = engine.state {
            return winner == aiPlayer ? 100 + depth : -100 - depth
        }
        if case .draw = engine.state {
            return 0
        }
        if depth == 0 {
            return evaluate(engine: engine, aiPlayer: aiPlayer)
        }

        let currentPlayer = isMaximizing ? aiPlayer : aiPlayer.opponent
        let moves = engine.validMoves(for: currentPlayer)

        if moves.isEmpty {
            return 0
        }

        var alpha = alpha
        var beta = beta

        if isMaximizing {
            var maxScore = Int.min
            for move in moves {
                var testEngine = engine
                guard testEngine.executeMove(move) else { continue }
                let score = minimax(engine: testEngine, depth: depth - 1, isMaximizing: false, aiPlayer: aiPlayer, alpha: alpha, beta: beta)
                maxScore = max(maxScore, score)
                alpha = max(alpha, score)
                if beta <= alpha { break }
            }
            return maxScore
        } else {
            var minScore = Int.max
            for move in moves {
                var testEngine = engine
                guard testEngine.executeMove(move) else { continue }
                let score = minimax(engine: testEngine, depth: depth - 1, isMaximizing: true, aiPlayer: aiPlayer, alpha: alpha, beta: beta)
                minScore = min(minScore, score)
                beta = min(beta, score)
                if beta <= alpha { break }
            }
            return minScore
        }
    }

    private func evaluate(engine: GameEngine, aiPlayer: Player) -> Int {
        var score = 0
        let aiPositions = engine.board.positions(for: engine.pieces(for: aiPlayer).map(\.id))
        let opponentPositions = engine.board.positions(for: engine.pieces(for: aiPlayer.opponent).map(\.id))

        for line in WinChecker.winningLines {
            let aiCount = line.filter { aiPositions.contains($0) }.count
            let opCount = line.filter { opponentPositions.contains($0) }.count

            if aiCount > 0 && opCount == 0 {
                score += aiCount * aiCount
            } else if opCount > 0 && aiCount == 0 {
                score -= opCount * opCount
            }
        }
        return score
    }
}
