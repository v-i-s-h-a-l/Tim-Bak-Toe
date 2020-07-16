//
//  PieceViewState.swift
//  XO3
//
//  Created by Vishal Singh on 06/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
import SwiftUI

enum PieceViewState {
    case disabled
    case dragged
    case placed
    
    case won
    case lost
    
    private var dragMultiplier: CGFloat {
        return 3.0
    }
    
    var scale: CGFloat {
        switch self {
        case .disabled, .placed, .lost: return 1
        case .dragged: return 1.1
        case .won: return 1.1
        }
    }
    
    var pieceColor: Color {
        Theme.Col.piece
    }
    
    var pieceStrokeColor: LinearGradient {
        switch self {
        case .disabled: return LinearGradient(Theme.Col.piece, Theme.Col.piece)
        case .placed, .won, .lost: return LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted)
        case .dragged: return LinearGradient(Theme.Col.lightSource, Theme.Col.boardCell, Theme.Col.boardCell)
        }
    }
    
    var lightSourceShadowColor: Color {
        switch self {
        case .disabled, .dragged, .won, .lost: return Theme.Col.shadowCasted
        case .placed: return Theme.Col.lightSource
        }
    }
    
    var zIndex: Double {
        switch self {
        case .disabled, .placed, .won, .lost: return ZIndex.playerPiecePlaced
        case .dragged: return ZIndex.playerPieceDragged
        }
    }
    
    var allowsHitTesting: Bool {
        return [Self.dragged, Self.placed].contains(self)
    }
    
    func shadowCastedRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 1
        case .dragged: return pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }
    
    func shadowCastedDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 0
        case .dragged: return pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }
    
    func lightSourceShadowRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 1
        case .dragged: return pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }
    
    func lightSourceShadowDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 0
        case .dragged: return pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }
    
    func bottomShadowLayer(pieceSize size: CGSize) -> some View {
        Circle()
            .fill(pieceColor)
            .shadow(color: lightSourceShadowColor, radius: lightSourceShadowRadius(for: size), x: -lightSourceShadowDisplacement(for: size), y: -lightSourceShadowDisplacement(for: size))
            .shadow(color: Theme.Col.shadowCasted, radius: shadowCastedRadius(for: size), x: shadowCastedDisplacement(for: size), y: shadowCastedDisplacement(for: size))
            .blur(radius: 1)
    }
    
    func upperFillLayer(pieceSize size: CGSize) -> some View {
        Group {
            Circle()
                .fill(pieceColor)
            Circle()
                .stroke(pieceStrokeColor, lineWidth: shadowCastedRadius(for: size) / 2.0)
        }
    }
}

