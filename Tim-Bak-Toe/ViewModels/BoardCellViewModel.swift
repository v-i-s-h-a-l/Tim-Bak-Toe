//
//  BoardCellViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

enum BoardCellState {
    case none // when no piece has been picked up for placement
    case occupied
    case origin // the current active piece was picked from this cell itself
    case welcome

    var shadowColor: Color {
        typealias TC = Theme.Col.Shadow.BoardCell
        switch self {
        case .none: return TC.none
            case .occupied: return TC.occupied
            case .origin: return TC.origin
            case .welcome: return TC.welcome
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .none: return 0
        case .occupied, .origin, .welcome: return 5
        }
    }
}

class BoardCellViewModel: ObservableObject, Identifiable {

    let id = UUID()
    var pieceId: UUID?

    @Published var cellState: BoardCellState = .none
    private var frameGlobal: CGRect!

    private var dragStartSubscription: AnyCancellable?
    private var dragChangeSubscription: AnyCancellable?
    private var dragEndedSubscription: AnyCancellable?

    func onAppear(_ proxy: GeometryProxy) {
        self.frameGlobal = proxy.frame(in: .global)
    }

    func subscribeToDragStart(_ publisher: PassthroughSubject<UUID?, Never>) {
        dragStartSubscription = publisher.sink(receiveValue: { cellId in
                if self.id == cellId {
                    self.cellState = .origin
                } else {
                    if self.pieceId != nil {
                        self.cellState = .occupied
                    } else {
                        self.cellState = .welcome
                    }
                }
            }
        )
    }

    func subscribeToDragChanged(_ publisher: PassthroughSubject<(CGPoint, UUID?), Never>) {
        dragChangeSubscription = publisher.sink(receiveValue: { point, cellId in
            if self.frameGlobal.contains(point) {
                if self.id == cellId {
                    self.cellState = .origin
                } else {
                    self.cellState = .welcome
                }
            } else {
                if self.pieceId != nil {
                    self.cellState = .occupied
                } else {
                    self.cellState = .welcome
                }
            }
        })
    }

    func subscribeToDragEnded(_ publisher: PassthroughSubject<(CGPoint, UUID?), Never>) {
        dragEndedSubscription = publisher.sink(receiveValue: { point, cellId in
            if self.frameGlobal.contains(point) {
                // some publishing and animation
            } else {
                self.cellState = .none
            }
        })
    }
}
