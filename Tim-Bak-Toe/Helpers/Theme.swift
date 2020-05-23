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
        static var piece = Color.red

        static var gameBackground = Color.gray.opacity(0.7)
        static var boardCell = Color.black

        enum Shadow {
            enum BoardCell {
                static var none = Color.clear
                static var occupied = Color.red
                static var origin = Color.blue
                static var welcome = Color.yellow
            }
        }
    }
}
