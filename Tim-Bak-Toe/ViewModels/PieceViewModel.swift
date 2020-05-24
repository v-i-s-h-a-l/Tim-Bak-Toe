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
    private var occupiedCellID: UUID?
    let style: PieceStyle
    let userId: UUID

    init(with style: PieceStyle) {
        self.style = style
        self.userId = (style == .circle1 ? hostId : peerId)
    }

    @Published var relativeOffset: CGSize = .zero
    @Published var disabled: Bool = false
    @Published var isDragStarted: Bool = false

    var dragStartedPublisher = PassthroughSubject<(UUID, UUID?), Never>()
    var draggedEndedPublisher = PassthroughSubject<(CGPoint, UUID, UUID?), Never>()

    private var cancellables: Set<AnyCancellable> = []

    private var dragAmount: CGSize = .zero
    private var currentOffset: CGSize = .zero

    private var centerGlobal: CGPoint = .zero

    func onAppear(_ proxy: GeometryProxy) {
        self.centerGlobal = proxy.frame(in: .global).center
    }

    // MARK: - functions to be called by view -
    
    func onDragChanged(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard !self.disabled else { return }
        if !isDragStarted {
            self.isDragStarted = true
            self.dragStartedPublisher
                .send((id, occupiedCellID))
        } else {
            self.dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
            self.relativeOffset = dragAmount + currentOffset
        }
    }
    
    func onDragEnded(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard !self.disabled else { return }
        isDragStarted = false
        draggedEndedPublisher
            .send((drag.location, id, occupiedCellID))
    }

    // MARK: - Internal functionality -
    
    fileprivate func pauseDrag(for seconds: Int = 3) {
        withAnimation {
            self.disabled = true
        }
        Just(false)
            .delay(for: .seconds(seconds), scheduler: RunLoop.current)
            .sink { value in
            withAnimation {
                self.disabled = value
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - functions called by game vm to provide publishers -

    func subscribeToDragStart(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher.sink { uuid in
            self.disabled = self.id != uuid
        }
        .store(in: &cancellables)
    }

    func subscribeToDragEnd(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            // waits for drop success calculations (if any)
            // if successful drop is there then currentOffset gets updated accordingly
            .delay(for: .milliseconds(20), scheduler: RunLoop.current)
            .sink { uuid in
                withAnimation {
                self.dragAmount = .zero
                self.relativeOffset = self.currentOffset
            }
        }
        .store(in: &cancellables)
        
        publisher
            .sink { _ in
                self.disabled = false
        }
        .store(in: &cancellables)
    }
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(CGPoint, UUID, UUID), Never>) {
        publisher
            .filter { (_, pieceId, _) in
                return pieceId == self.id
            }
        .sink { (newCellCenter, _, newCellId) in
            self.occupiedCellID = newCellId
            self.currentOffset = newCellCenter - self.centerGlobal
        }
        .store(in: &cancellables)

        publisher
            .sink { (_, _, _) in
                self.pauseDrag()
        }
        .store(in: &cancellables)
    }
}
