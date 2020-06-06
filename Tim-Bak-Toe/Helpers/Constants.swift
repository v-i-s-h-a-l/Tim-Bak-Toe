//
//  Constants.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 24/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

enum ZIndex {
    static let board = 0.0

    static let playerPiecePlaced = 1.0
    static let playerPieceDragged = 2.0
}

enum Points {
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    static let boardWidthMultiplier: CGFloat = isPad ? 0.65 : 0.85
    static let cellPadding: CGFloat = isPad ? 15 : 10
    static let screenEdgePadding: CGFloat = isPad ? 30 : 15
}


enum UIUserInterfaceIdiom: Int {
    case unspecified

    case phone
    case pad
}
