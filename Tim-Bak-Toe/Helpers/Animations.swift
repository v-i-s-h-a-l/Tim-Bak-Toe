//
//  Animations.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
import SwiftUI

struct ScaleEffect: GeometryEffect {
    var scaleX: CGFloat = 1.0
    var scaleY: CGFloat = 1.0
    
    var animatableData: (CGFloat, CGFloat) {
        get { (scaleX, scaleY) }
        set { (scaleX, scaleY) = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
