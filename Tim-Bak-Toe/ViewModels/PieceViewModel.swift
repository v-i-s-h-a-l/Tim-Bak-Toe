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

    @Published var dragAmount: CGSize = .zero
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
        dragAmount = .zero
        draggedEndedPublisher
            .send((drag.location, id, occupiedCellID))
    }
}
