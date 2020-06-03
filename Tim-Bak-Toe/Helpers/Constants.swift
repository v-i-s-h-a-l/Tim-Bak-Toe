//
//  Constants.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 24/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import CoreGraphics
import Foundation

enum ZIndex {
    static let board = 0.0

    static let enemyPiece = 0.1

    static let playerPiecePlaced = 0.3
    static let playerPieceDragged = 0.4
}

enum Points {
    static let boardWidthMultiplier: CGFloat = 0.85
    static let cellPadding: CGFloat = 10
}
