//
//  Theme.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 23/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
import SwiftUI

enum Theme {
    enum Col {
        static let piece = Color(UIColor(named: "piece")!)

        static let gameBackground = Color(UIColor(named: "background")!)
        static let boardCell = Color(UIColor(named: "boardCell")!)

        static let lightSource = Color(UIColor(named: "lightSource")!)
        static let shadowCasted = Color(UIColor(named: "shadowCasted")!)
        
        static let redStart = Color(UIColor(named: "redStart")!)
        static let redEnd = Color(UIColor(named: "redEnd")!)
        
        static let blueStart = Color(UIColor(named: "blueStart")!)
        static let blueEnd = Color(UIColor(named: "blueEnd")!)


        enum Shadow {
            enum BoardCell {
                static let none = Color.clear
                static let occupied = Color.red
                static let origin = Color.blue
                static let welcome = Color.yellow
            }            
        }
    }
}

extension LinearGradient {
    init(_ colors: Color..., startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}
