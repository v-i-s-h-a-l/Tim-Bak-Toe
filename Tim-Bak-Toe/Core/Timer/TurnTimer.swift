import Foundation
import Observation

@MainActor @Observable
final class TurnTimer {
    var fillRatio: Double = 1.0
    private(set) var isRunning = false

    private var timerTask: Task<Void, Never>?
    private let tickInterval: TimeInterval = 0.1
    private var duration: TimeInterval
    private var elapsed: TimeInterval = 0

    var onExpiry: (() -> Void)?

    init(duration: TimeInterval = 5.0) {
        self.duration = duration
    }

    func updateDuration(_ newDuration: TimeInterval) {
        duration = newDuration
    }

    func start() {
        stop()
        elapsed = 0
        fillRatio = 1.0
        isRunning = true

        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                guard !Task.isCancelled, let self else { return }
                self.elapsed += self.tickInterval
                let ratio = max(0, 1.0 - self.elapsed / self.duration)
                self.fillRatio = ratio
                if ratio <= 0 {
                    self.isRunning = false
                    self.onExpiry?()
                    return
                }
            }
        }
    }

    func stop() {
        timerTask?.cancel()
        timerTask = nil
        isRunning = false
    }

    func reset() {
        stop()
        fillRatio = 1.0
        elapsed = 0
    }
}
