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
    case waiting, emptyingDown, fillingUp
}

class TimerViewModel: ObservableObject {

    let teamId: UUID
    let refillingDuration: Double
    let style: PieceStyle
    
    @Published var currentFill: CGFloat = 1.0

    init(with teamId: UUID, style: PieceStyle, refillingDuration: Double = 6.0) {
        self.teamId = teamId
        self.refillingDuration = refillingDuration
        self.style = style
    }

    var refillSuccessPublisher = PassthroughSubject<UUID, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var timerObserver: AnyCancellable?
    
    private let timerStride = 0.7

    private var state: TimerState = .emptyingDown
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?

    private lazy var emptyingDuration: Double = refillingDuration
    private lazy var fillingDuration: Double = refillingDuration
    private var currentTime: Double = 0 {
        didSet {
            var ratio = currentTime / refillingDuration
            if ratio >= 1 { ratio = 1.0 }
            if ratio <= 0 { ratio = 0.0}

            currentFill = CGFloat(ratio)
        }
    }
    
    // MARK: - Functionality -

    func invokeEmptying() {
        withAnimation {
            currentTime = 0.0
        }
        state = .fillingUp
        resetTimer()
    }

    func invokeRefilling() {
        withAnimation {
            currentTime = refillingDuration
        }
        state = .emptyingDown
        resetTimer()
    }

    // MARK: - Successful drop for a team -
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<UUID, Never>) {
        // instant empty for self
        publisher
            .filter { $0 == self.teamId }
            .sink { _ in
                self.invokeEmptying()
        }
        .store(in: &cancellables)

        // instant refill for opponent
        publisher
            .filter { $0 != self.teamId }
            .sink { _ in
                self.invokeRefilling()
        }
        .store(in: &cancellables)
    }
    
    func subscribeToWin(_ publisher: PassthroughSubject<Void, Never>) {
        publisher.sink { _ in
            self.timerObserver?.cancel()
            self.timer = nil
        }
        .store(in: &cancellables)
    }

    func subscribeToRestart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher.sink { _ in
            self.reset()
        }
        .store(in: &cancellables)
    }

    private func reset() {
        currentTime = refillingDuration
        state = .waiting
        resetTimer()
    }

    // MARK: - starting a new game -

    func subscribeToGameStart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher.sink { _ in
            self.resetTimer()
        }
        .store(in: &cancellables)
    }
    
    private func resetTimer() {
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
        guard self.state != .waiting else { return }

        // toggle states if needed
        if currentTime >= refillingDuration {
            currentTime = refillingDuration
            state = .emptyingDown
            refillSuccessPublisher.send(teamId)
        } else if currentTime <= 0.0 {
            currentTime = 0.0
            state = .fillingUp
        }

        // update fill amount
        withAnimation(Animation.easeInCubic) {
            if state == .emptyingDown {
                currentTime -= timerStride
            } else if state == .fillingUp {
                currentTime += timerStride
            }
        }
    }
}
