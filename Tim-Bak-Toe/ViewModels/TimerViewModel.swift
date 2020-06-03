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

class TimerViewModel: ObservableObject {

    let teamId: UUID
    let refillingDuration: Double
    let style: PieceStyle
    
    @Published var isEmpty: Bool = false

    init(with teamId: UUID, style: PieceStyle, refillingDuration: Double = 3.0) {
        self.teamId = teamId
        self.refillingDuration = refillingDuration
        self.style = style
    }

    var refillSuccessPublisher = PassthroughSubject<UUID, Never>()
    
    private var cancellables = Set<AnyCancellable>()

    private var emptyingDuration: Double {
        refillingDuration
    }
    private var fillingDuration: Double {
        refillingDuration
    }
    
    // MARK: - Functionality -
    
    func invokeEmptying() {
        withAnimation(Animation.linear(duration: emptyingDuration)) {
            self.isEmpty = true
        }
    }

    func invokeRefilling() {
        Just(1)
            .delay(for: .seconds(emptyingDuration), scheduler: RunLoop.current)
            .sink { _ in
                withAnimation(Animation.linear(duration: self.fillingDuration)) {
                    self.isEmpty = false
                }
        }
        .store(in: &cancellables)

        Just(1)
            .delay(for: .seconds(2 * refillingDuration), scheduler: RunLoop.current)
            .sink { _ in
                self.refillSuccessPublisher.send(self.teamId)
        }
    .store(in: &cancellables)
    }

    // MARK: - Successful drop for a team -
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
        .print("Shelf teamid: \(teamId)")
            .filter { $0 == self.teamId }
            .sink { _ in
                // start emptying
                self.invokeEmptying()

                // start refilling (happens after a little delay
                self.invokeRefilling()
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
        isEmpty = false
    }
}
