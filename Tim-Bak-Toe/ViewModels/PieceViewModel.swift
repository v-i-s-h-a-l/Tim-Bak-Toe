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

    var cancellables: Set<AnyCancellable> = []

    @Published var relativeOffset: CGSize = .zero
    @Published var disabled: Bool = false
    //    @State private var dragState: DragState = .unknown
    private var timer: Timer!
    
    private var dragAmount: CGSize = .zero
    private var currentOffset: CGSize = .zero

    private var isDragStarted: Bool = false
    private var frameGlobal: CGRect = .zero
    private var centerGlobal: CGPoint {
        frameGlobal.center
    }

    func onAppear(_ proxy: GeometryProxy) {
        self.frameGlobal = proxy.frame(in: .global)
    }

    // MARK: - functions called by view -
    
    func onDragChanged(_ drag: DragGesture.Value) {
        if !isDragStarted {
            self.isDragStarted = true
            self.dragStartedPublisher
                .send((id, occupiedCellID))
        }
        self.dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
        self.relativeOffset = dragAmount + currentOffset
        
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
        publisher.sink { uuid in
            self.disabled = self.id != uuid
        }
        .store(in: &cancellables)
    }

    func subscribeToDragEnd(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher.sink { uuid in
            withAnimation {
                self.disabled = false
                self.dragAmount = .zero
                self.relativeOffset = self.currentOffset
            }
        }
        .store(in: &cancellables)
    }

    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(CGPoint, UUID, UUID, UUID?), Never>) {
        publisher
            .map({ x -> (CGPoint, UUID, UUID, UUID?) in
                self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                    withAnimation {
                        if !self.disabled {
                            self.disabled = true
                        } else {
                            self.disabled = false
                            self.timer.invalidate()
                        }
                    }
                }
                self.timer.fire()
                return x
            })
            .filter { (_, pieceId, _, _) in
                pieceId == self.id
            }
        .sink { (newCellCenter, _, newCellId, _) in
            self.currentOffset = CGSize(width: newCellCenter.x - self.centerGlobal.x, height: newCellCenter.y - self.centerGlobal.y)
            self.occupiedCellID = newCellId
            withAnimation {
                self.relativeOffset = self.currentOffset + self.dragAmount
            }
        }
        .store(in: &cancellables)
    }
}
