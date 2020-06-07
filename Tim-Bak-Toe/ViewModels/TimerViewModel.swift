//
//  TimerViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

enum TimerState: String {
    case emptyingDown, waiting
}

class TimerViewModel: ObservableObject {

    let teamId: UUID
    let refillingDuration: Double
    let style: PieceStyle
    
    @Published var currentFill: CGFloat = 1.0

    init(with teamId: UUID, style: PieceStyle, refillingDuration: Double = 5) {
        self.teamId = teamId
        self.refillingDuration = refillingDuration
        self.style = style
    }

    var emptyPublisher = PassthroughSubject<UUID, Never>()

    private var cancellables = Set<AnyCancellable>()
    private var timerObserver: AnyCancellable?
    
    private let timerStride = 1.0

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?

    private var currentState: TimerState = .waiting
    private var currentTime: Double = 0 {
        didSet {
            guard oldValue != currentTime else { return }
            var ratio = currentTime / refillingDuration
            if ratio >= 1 { ratio = 1.0 }
            if ratio <= 0 { ratio = 0.0}

            if self.currentState == .waiting {
                withAnimation {
                    currentFill = CGFloat(ratio)
                }
            } else {
                withAnimation(Animation.linear(duration: 1.0)) {
                    currentFill = CGFloat(ratio)
                }
            }
        }
    }

    // MARK: - Successful drop for a team -
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<UUID, Never>) {
        // instant empty for self
        publisher
            .filter { $0 == self.teamId }
            .sink { _ in
                self.reset() }
        .store(in: &cancellables)

        // instant refill for opponent
        publisher
            .filter { $0 != self.teamId }
            .sink { _ in
                self.resetAndStartTimer()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - A timer emptied -

    func subscribeToEmptiedTimer(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher.sink { teamId in
            if self.teamId == teamId {
                self.reset()
            } else {
                self.resetAndStartTimer()
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Any team wins -

    func subscribeToWin(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher.sink { _ in
            self.reset()
        }
        .store(in: &cancellables)
    }

    // MARK: - Game restarts -

    func subscribeToRestart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher.sink { _ in
            self.reset()
        }
        .store(in: &cancellables)
    }

    private func reset() {
        timerObserver?.cancel()
        timer = nil
        currentState = .waiting
        currentTime = refillingDuration
    }

    // MARK: - Starting a new game -

    func subscribeToGameStart(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher.sink { teamId in
            if self.teamId == teamId {
                self.resetAndStartTimer()
            }
        }
        .store(in: &cancellables)
    }
    
    private func resetAndStartTimer() {
//        currentTime = refillingDuration
        currentState = .emptyingDown
        timerObserver?.cancel()

        timer = nil
        timer = Timer.publish(every: timerStride, on: .current, in: .default).autoconnect()
        startObservingTimer()
    }

    private func startObservingTimer() {
        timerObserver = timer?.sink { _ in
            self.invokeTimerActions()
        }
    }

    private func invokeTimerActions() {
        // toggle states if needed
        currentTime -= timerStride
        if currentTime <= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + timerStride) {
                self.emptyPublisher.send(self.teamId)
            }
        }
    }
}
