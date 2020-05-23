//
//  BoardCellView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct BoardCellView: View {
    
    @ObservedObject var viewModel = BoardCellViewModel()
    
    var body: some View {
        Theme.Col.boardCell
            .opacity(0.8)
            .shadow(color: viewModel.cellState.shadowColor,
                    radius: viewModel.cellState.shadowRadius)
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear(perform: {
                            self.viewModel.onAppear(proxy)
                        })
            })
    }
}

struct BoardCellView_Previews: PreviewProvider {
    static var previews: some View {
        BoardCellView()
    }
}
