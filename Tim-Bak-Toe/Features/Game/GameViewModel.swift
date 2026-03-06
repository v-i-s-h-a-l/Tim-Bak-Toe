import SwiftUI
import Observation

@MainActor @Observable
final class GameViewModel {
    private(set) var engine = GameEngine()
    var pieceStates: [UUID: PieceUIState] = [:]
    var cellFrames: [BoardPosition: CGRect] = [:]

    var showWinnerView = false
    var gameMode: GameMode = .localMultiplayer

    let xTimer = TurnTimer()
    let oTimer = TurnTimer()

    private var aiTask: Task<Void, Never>?
    private var aiStrategy: (any AIStrategy)?

    var timerDuration: TimeInterval {
        get { xTimer.fillRatio > 0 ? 5.0 : 5.0 }
    }

    init() {
        setupPieceStates()
        setupTimerCallbacks()
    }

    // MARK: - Setup

    private func setupPieceStates() {
        for piece in engine.allPieces() {
            pieceStates[piece.id] = PieceUIState(piece: piece)
        }
    }

    private func setupTimerCallbacks() {
        xTimer.onExpiry = { [weak self] in self?.handleTimerExpiry(for: .x) }
        oTimer.onExpiry = { [weak self] in self?.handleTimerExpiry(for: .o) }
    }

    // MARK: - Game Lifecycle

    func startGame(mode: GameMode) {
        gameMode = mode
        switch mode {
        case .vsAI(let difficulty):
            switch difficulty {
            case .easy: aiStrategy = EasyAI()
            case .medium: aiStrategy = MediumAI()
            case .hard: aiStrategy = HardAI()
            }
        case .localMultiplayer:
            aiStrategy = nil
        }

        engine.startGame()
        startTimerForCurrentTurn()
    }

    func restart() {
        aiTask?.cancel()
        aiTask = nil
        xTimer.reset()
        oTimer.reset()
        engine.reset()

        withAnimation {
            showWinnerView = false
            pieceStates.removeAll()
        }

        setupPieceStates()
        engine.startGame()
        startTimerForCurrentTurn()
    }

    // MARK: - Piece Accessors

    func xPieceStates() -> [PieceUIState] {
        engine.xPieces.compactMap { pieceStates[$0.id] }
    }

    func oPieceStates() -> [PieceUIState] {
        engine.oPieces.compactMap { pieceStates[$0.id] }
    }

    // MARK: - Timer

    private func startTimerForCurrentTurn() {
        guard let turn = engine.state.currentTurn else { return }
        xTimer.reset()
        oTimer.reset()

        let duration = UserDefaults.standard.object(forKey: "timerDuration") as? Double ?? 5.0
        xTimer.updateDuration(duration)
        oTimer.updateDuration(duration)

        switch turn {
        case .x: xTimer.start()
        case .o: oTimer.start()
        }
    }

    func handleTimerExpiry(for player: Player) {
        guard engine.state.currentTurn == player else { return }

        // Force snap back any dragging piece
        for (id, state) in pieceStates where state.owner == player && state.viewState == .dragged {
            snapPieceBack(id)
        }

        engine.wasteTurn()

        if engine.state.isGameOver {
            handleGameOver()
        } else {
            enablePiecesForCurrentTurn()
            startTimerForCurrentTurn()
            triggerAIMoveIfNeeded()
        }
    }

    // MARK: - Drag and Drop

    func cellAppeared(at position: BoardPosition, frame: CGRect) {
        cellFrames[position] = frame
    }

    func pieceDragChanged(_ pieceId: UUID, drag: DragGesture.Value) {
        guard var state = pieceStates[pieceId] else { return }
        guard state.viewState != .disabled else { return }

        if state.viewState != .dragged {
            Sound.pop.play()

            // Disable sibling pieces
            disableSiblingPieces(of: pieceId, owner: state.owner)

            state.dragStartOffset = CGSize(
                width: drag.startLocation.x - (state.currentOffset.width + state.centerGlobal.x),
                height: drag.startLocation.y - (state.currentOffset.height + state.centerGlobal.y)
            )
            state.viewState = .dragged
            state.zIndex = LayoutConstants.ZIndex.playerPieceDragged
            state.scale = PieceViewState.dragged.scale
        }

        state.dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
        withAnimation(.easeOutQuart) {
            state.relativeOffset = state.dragAmount + state.currentOffset + state.dragStartOffset
        }
        pieceStates[pieceId] = state
    }

    func pieceDragEnded(_ pieceId: UUID, drag: DragGesture.Value) {
        guard let state = pieceStates[pieceId] else { return }
        guard state.viewState != .disabled else { return }

        let dropLocation = drag.location

        // Hit-test against cell frames
        var placed = false
        for (position, frame) in cellFrames {
            if frame.contains(dropLocation) && engine.board.isEmpty(at: position) {
                let move = Move(pieceId: pieceId, from: state.occupiedCellId, to: position)
                if engine.isValidMove(move) {
                    executeVisualMove(pieceId: pieceId, to: position, cellCenter: frame.center)
                    placed = true
                    break
                }
            }
        }

        if !placed {
            snapPieceBack(pieceId)
        }

        enablePiecesForCurrentTurn()
    }

    private func executeVisualMove(pieceId: UUID, to position: BoardPosition, cellCenter: CGPoint) {
        guard var state = pieceStates[pieceId] else { return }

        // Remove from old cell if repositioning
        if state.occupiedCellId != nil {
            // Old cell freed
        }

        let move = Move(pieceId: pieceId, from: state.occupiedCellId, to: position)
        let success = engine.executeMove(move)
        guard success else {
            snapPieceBack(pieceId)
            return
        }

        Sound.place.play()

        state.occupiedCellId = position
        state.currentOffset = cellCenter - state.centerGlobal
        state.dragAmount = .zero
        state.dragStartOffset = .zero
        state.viewState = .placed
        state.scale = PieceViewState.placed.scale
        state.zIndex = LayoutConstants.ZIndex.playerPiecePlaced

        withAnimation {
            state.relativeOffset = state.currentOffset
        }
        pieceStates[pieceId] = state

        if engine.state.isGameOver {
            handleGameOver()
        } else {
            enablePiecesForCurrentTurn()
            startTimerForCurrentTurn()
            triggerAIMoveIfNeeded()
        }
    }

    private func snapPieceBack(_ pieceId: UUID) {
        guard var state = pieceStates[pieceId] else { return }
        state.dragAmount = .zero
        state.dragStartOffset = .zero
        state.viewState = .placed
        state.scale = PieceViewState.placed.scale
        state.zIndex = LayoutConstants.ZIndex.playerPiecePlaced
        withAnimation {
            state.relativeOffset = state.currentOffset
        }
        pieceStates[pieceId] = state
    }

    private func disableSiblingPieces(of pieceId: UUID, owner: Player) {
        for (id, var state) in pieceStates where state.owner == owner && id != pieceId {
            state.viewState = .disabled
            pieceStates[id] = state
        }
    }

    private func enablePiecesForCurrentTurn() {
        guard let turn = engine.state.currentTurn else { return }
        for (id, var state) in pieceStates {
            if state.owner == turn {
                if state.viewState == .disabled || state.viewState == .dragged {
                    state.viewState = .placed
                    state.scale = PieceViewState.placed.scale
                    state.zIndex = LayoutConstants.ZIndex.playerPiecePlaced
                }
            } else {
                state.viewState = .disabled
            }
            pieceStates[id] = state
        }
    }

    // MARK: - Game Over

    private func handleGameOver() {
        xTimer.stop()
        oTimer.stop()

        switch engine.state {
        case .won(let winner):
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Sound.win.play()
            }
            for (id, var state) in pieceStates {
                if state.owner == winner {
                    state.viewState = .won
                } else {
                    state.viewState = .lost
                }
                pieceStates[id] = state
            }
        case .draw:
            for (id, var state) in pieceStates {
                state.viewState = .lost
                pieceStates[id] = state
            }
        default:
            break
        }

        withAnimation {
            showWinnerView = true
        }
    }

    // MARK: - AI

    func triggerAIMoveIfNeeded() {
        guard let ai = aiStrategy else { return }
        guard engine.state.currentTurn == .o else { return }

        // Disable all O pieces visually during AI thinking
        for (id, var state) in pieceStates where state.owner == .o {
            state.viewState = .disabled
            pieceStates[id] = state
        }

        aiTask = Task { @MainActor [weak self] in
            guard let self else { return }

            try? await Task.sleep(for: .milliseconds(700))
            guard !Task.isCancelled else { return }

            guard let move = await ai.selectMove(engine: self.engine, player: .o) else { return }
            guard !Task.isCancelled else { return }

            guard let cellFrame = self.cellFrames[move.to] else { return }
            self.executeAIMove(move, cellCenter: cellFrame.center)
        }
    }

    private func executeAIMove(_ move: Move, cellCenter: CGPoint) {
        guard var state = pieceStates[move.pieceId] else { return }

        let success = engine.executeMove(move)
        guard success else { return }

        Sound.place.play()

        state.occupiedCellId = move.to
        state.currentOffset = cellCenter - state.centerGlobal
        state.dragAmount = .zero
        state.dragStartOffset = .zero
        state.viewState = .placed
        state.scale = PieceViewState.placed.scale
        state.zIndex = LayoutConstants.ZIndex.playerPiecePlaced

        withAnimation(.easeOutQuart(duration: 0.4)) {
            state.relativeOffset = state.currentOffset
        }
        pieceStates[move.pieceId] = state

        if engine.state.isGameOver {
            handleGameOver()
        } else {
            enablePiecesForCurrentTurn()
            startTimerForCurrentTurn()
        }
    }
}
