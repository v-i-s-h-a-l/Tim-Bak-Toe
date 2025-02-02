//
//  BoardCellView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct BoardCellView: View {
    
    @ObservedObject var viewModel: BoardCellViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.Col.boardCell)
            Circle()
                .stroke(LinearGradient(Theme.Col.shadowCasted, Theme.Col.lightSource), lineWidth: Points.isPad ? 6 : 3) }
            .padding(Points.cellPadding)
            .overlay(GeometryReader { proxy in
                Color.clear
                    .onAppear(perform: {
                        self.viewModel.onAppear(proxy) })
            })
    }
}
