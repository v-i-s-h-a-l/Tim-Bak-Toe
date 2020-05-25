//
//  ShelfViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ShelfViewModel: ObservableObject {

    let teamId: UUID
    let refillingDuration: Double
    
    @Published var isEmpty: Bool = false

    init(with teamId: UUID, refillingDuration: Double = 3.0) {
        self.teamId = teamId
        self.refillingDuration = refillingDuration
    }

    var refillSuccessPublisher = PassthroughSubject<UUID, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functionality -
    
    func invokeEmptying() {
        withAnimation(Animation.linear(duration: 0.2)) {
            self.isEmpty = true
        }
    }
    

    // MARK: - Successful drop for a team -
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .filter { $0 == self.teamId }
            .sink { _ in
                // start emptying
                self.invokeEmptying()
        }
        .store(in: &cancellables)
    }
    
    // on getting emptied refill with animation
    // publish successful refilling
}
