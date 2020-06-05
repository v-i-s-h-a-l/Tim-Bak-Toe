//
//  AccessibilityIdentifier.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 05/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
import SwiftUI

enum ScreenElement { // stands for game screen element
    case hostPiece(Int)
    case peerPiece(Int)
    case boardCell(Int, Int)
    
    var identifier: String {
        switch self {
        case .hostPiece(let index): return "HostPiece\(index)"
        case .peerPiece(let index): return "PeerPiece\(index)"
        case .boardCell(let row, let column): return "BoardCell\(row)\(column)"
        }
    }
}


extension View {

    func setAccessibilityIdentifier(element: ScreenElement) -> some View {
        return self.accessibility(identifier: element.identifier)
    }
}
