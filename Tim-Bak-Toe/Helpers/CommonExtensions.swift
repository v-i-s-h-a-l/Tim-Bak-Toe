//
//  CommonExtensions.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 23/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
import SwiftUI

extension CGPoint {

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGSize {
        return CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
}

extension CGSize {

    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension CGRect {

    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
