//
//  PieceViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class PieceViewModel: ObservableObject, Identifiable {
    let id = UUID()
    var occupiedCellID: UUID?

    var dragStartedPublisher = PassthroughSubject<(UUID, UUID?), Never>()
    var draggedPublisher = PassthroughSubject<(CGPoint, UUID, UUID?), Never>()
    var draggedEndedPublisher = PassthroughSubject<(CGPoint, UUID, UUID?), Never>()

    var dragStartByFellowPieceCancellable: AnyCancellable?
    var dragEndedByFellowPieceCancellable: AnyCancellable?

    @Published var dragAmount: CGSize = .zero
    @Published var disabled: Bool = false
    //    @State private var dragState: DragState = .unknown
    
    private var isDragStarted: Bool = false

    // MARK: - functions called by view -
    
    func onDragChanged(_ drag: DragGesture.Value) {
        if !isDragStarted {
            self.isDragStarted = true
            self.dragStartedPublisher
                .send((id, occupiedCellID))
        }
        self.dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
        
        self.draggedPublisher
            .send((drag.location, id, occupiedCellID))
        //        self.dragState = self.onChanged?(drag.location, self.text) ?? .unknown
    }
    
    func onDragEnded(_ drag: DragGesture.Value) {
        isDragStarted = false
        draggedEndedPublisher
            .send((drag.location, id, occupiedCellID))
    }
    
    // MARK: - functions called by game vm to provide publishers -

    func subscribeToDragStart(_ publisher: PassthroughSubject<UUID, Never>) {
        dragStartByFellowPieceCancellable = publisher.sink { uuid in
            self.disabled = self.id != uuid
        }
    }

    func subscribeToDragEnd(_ publisher: PassthroughSubject<UUID, Never>) {
        dragEndedByFellowPieceCancellable = publisher.sink { uuid in
            withAnimation {
                self.disabled = false
                self.dragAmount = .zero
            }
        }
    }
}
