import Foundation

@MainActor
final class MultiplayerAdapter {
    let gameCenterManager: GameCenterManager
    weak var viewModel: GameViewModel?
    var localRole: Player { gameCenterManager.localRole }

    var onRematchRequested: (() -> Void)?
    var onRematchAccepted: (() -> Void)?
    var onOpponentResigned: (() -> Void)?
    var onOpponentDisconnected: (() -> Void)?

    var rematchRequestedByRemote = false
    var rematchRequestedByLocal = false

    init(gameCenterManager: GameCenterManager) {
        self.gameCenterManager = gameCenterManager
        setupCallbacks()
    }

    private func setupCallbacks() {
        gameCenterManager.onMessageReceived = { [weak self] message in
            self?.handleMessage(message)
        }
        gameCenterManager.onPlayerDisconnected = { [weak self] in
            self?.handleDisconnection()
        }
    }

    // MARK: - Outgoing

    func localMoveExecuted(pieceId: UUID) {
        guard let vm = viewModel else { return }
        let player = localRole
        let pieces = vm.engine.pieces(for: player)
        guard let pieceIndex = pieces.firstIndex(where: { $0.id == pieceId }) else { return }

        let piece = pieces[pieceIndex]
        guard let to = piece.boardPosition else { return }

        // Determine `from`: if the piece was relocated, we need the previous position.
        // After executeMove, boardPosition is already updated to `to`.
        // We get from via the PieceUIState's previous occupiedCellId before the move.
        // However, the engine already executed, so we check: was this a placement or relocation?
        // A placement move has from=nil. A relocation has from=some position.
        // We stored this in the move itself. Let's get it from the view model.
        let from = vm.lastExecutedMoveFrom

        gameCenterManager.send(.move(pieceIndex: pieceIndex, from: from, to: to))
    }

    func localTimerExpired() {
        gameCenterManager.send(.wasteTurn)
    }

    func requestRematch() {
        rematchRequestedByLocal = true
        gameCenterManager.send(.rematchRequest)
        if rematchRequestedByRemote {
            triggerRematch()
        }
    }

    func sendResigned() {
        gameCenterManager.send(.resigned)
        gameCenterManager.disconnect()
    }

    // MARK: - Incoming

    private func handleMessage(_ message: MultiplayerMessage) {
        guard let vm = viewModel else { return }

        switch message {
        case .move(let pieceIndex, let from, let to):
            let opponentRole = localRole.opponent
            let pieces = vm.engine.pieces(for: opponentRole)
            guard pieceIndex < pieces.count else { return }
            let pieceId = pieces[pieceIndex].id
            vm.applyRemoteMove(pieceId: pieceId, from: from, to: to)

        case .wasteTurn:
            vm.applyRemoteWasteTurn()

        case .rematchRequest:
            rematchRequestedByRemote = true
            if rematchRequestedByLocal {
                triggerRematch()
            } else {
                onRematchRequested?()
            }

        case .rematchAccepted:
            triggerRematch()

        case .resigned:
            onOpponentResigned?()
        }
    }

    private func handleDisconnection() {
        viewModel?.handleRemoteDisconnection()
        onOpponentDisconnected?()
    }

    private func triggerRematch() {
        rematchRequestedByLocal = false
        rematchRequestedByRemote = false
        onRematchAccepted?()
    }

    func isLocalPlayerTurn() -> Bool {
        viewModel?.engine.state.currentTurn == localRole
    }
}
