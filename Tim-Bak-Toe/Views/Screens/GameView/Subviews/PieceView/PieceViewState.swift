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
    
    private var dragMultiplier: CGFloat {
        return 3.0
    }

    var scale: CGFloat {
        switch self {
        case .disabled, .placed: return 1
        case .dragged: return 1.1
        }
    }

    var pieceColor: LinearGradient {
        switch self {
        case .disabled: return LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted)
        case .dragged: return LinearGradient(Theme.Col.boardCell, Theme.Col.boardCell)
        case .placed: return LinearGradient(Theme.Col.piece, Theme.Col.piece)
        }
    }

    var pieceStrokeColor: LinearGradient {
        switch self {
        case .disabled, .placed: return LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted)
        case .dragged: return LinearGradient(Theme.Col.lightSource, Theme.Col.boardCell, Theme.Col.boardCell)
        }
    }

    var lightSourceShadowColor: Color {
        switch self {
        case .disabled, .dragged: return .clear
        case .placed: return Theme.Col.lightSource
        }
    }

    var zIndex: Double {
        switch self {
        case .disabled, .placed: return 0.0
        case .dragged: return 1.0
        }
    }

    var allowsHitTesting: Bool {
        return self != .disabled
    }

    func shadowCastedRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled: return 0
        case .dragged: return 2 * dragMultiplier * pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }

    func shadowCastedDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled: return 0
        case .dragged: return dragMultiplier * pieceSize.height / 40.0
        case .placed: return pieceSize.height / 40.0
        }
    }

    func lightSourceShadowRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .dragged: return 0
        case .placed: return pieceSize.height / 40.0
        }
    }

    func lightSourceShadowDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled: return 0
        case .dragged: return 0
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
            return Group {
                if self == .disabled {
                    Circle()
                        .fill(LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted))
                }
                if self == .dragged || self == .placed {
                    Circle()
                        .fill(pieceColor)
                    Circle()
                        .stroke(pieceStrokeColor, lineWidth: shadowCastedRadius(for: size) / 2.0)
                        .blur(radius: 1)
                }
            }
    }
}

