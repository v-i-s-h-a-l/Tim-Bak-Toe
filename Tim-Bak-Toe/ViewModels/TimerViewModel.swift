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
    let style: PieceStyle
    private var gameSettings = GameSettings.user

    @Published var currentFill: CGFloat = 1.0

    init(with teamId: UUID, style: PieceStyle) {
        self.teamId = teamId
        self.style = style
        self.currentTime = GameSettings.user.timerDuration
    }

    var emptyPublisher = PassthroughSubject<UUID, Never>()

    private var cancellables = Set<AnyCancellable>()

    private var currentState: TimerState = .waiting

    private var currentTime: Double {
        didSet {
            guard oldValue != currentTime else { return }
            var ratio = currentTime / gameSettings.timerDuration
            if ratio >= 1 { ratio = 1.0 }
            if ratio <= 0 { ratio = 0.0 }

            if self.currentState == .waiting {
                withAnimation {
                    currentFill = CGFloat(ratio)
                }
            } else {
                withAnimation(Animation.linear(duration: gameSettings.timerStride + 0.1)) {
                    currentFill = CGFloat(ratio)
                }
            }
        }
    }

//    // MARK: - Starting a new game -

    func subscribeToGameStart(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .filter { self.teamId == $0 }
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { _ in self.startTimer() }
            .store(in: &cancellables)
    }

    // MARK: - Successful drop for a team -
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .filter { self.teamId == $0 }
            .sink { _ in self.reset() }
            .store(in: &cancellables)

        publisher
            .filter { self.teamId != $0 }
            .sink { _ in self.startTimer() }
            .store(in: &cancellables)
    }
    
    // MARK: - A timer emptied -

    func subscribeToEmptiedTimer(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .filter { self.teamId == $0 }
            .sink { _ in self.reset() }
            .store(in: &cancellables)

        publisher
            .filter { self.teamId != $0 }
            .sink { _ in self.startTimer() }
            .store(in: &cancellables)
    }

    // MARK: - Any team wins -

    func subscribeToWin(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .sink { _ in self.reset() }
            .store(in: &cancellables)
    }

    // MARK: - Game restarts -

    func subscribeToRestart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher
            .sink { _ in self.reset() }
            .store(in: &cancellables)
    }

    // MARK: - Internal functionalities -

    private func reset() {
        currentState = .waiting
        currentTime = gameSettings.timerDuration
    }
    
    private func startTimer() {
        currentState = .emptyingDown
        invokeTimerActions()
    }

    private func invokeTimerActions() {
        guard self.currentState == .emptyingDown else { return }
        currentTime -= gameSettings.timerStride
        DispatchQueue.main.asyncAfter(deadline: .now() + gameSettings.timerStride) { [weak self] in
            guard let self = self else { return }
            if self.currentTime <= 0 {
                self.emptyPublisher.send(self.teamId)
            }
            self.invokeTimerActions()
        }
    }
}
