//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PieceView: View {
    var body: some View {
        Circle()
            .overlay(Color.red)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView()
    }
}
