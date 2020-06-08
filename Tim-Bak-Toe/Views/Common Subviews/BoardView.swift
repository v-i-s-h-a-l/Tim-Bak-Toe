//
//  BoardView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct BoardView: View {

    let boardSize: CGSize
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            Spacer()
            GridStack(rows: 3, columns: 3, content: cell)
                .frame(width: boardSize.width, height: boardSize.height)
            Spacer()
        }
        .zIndex(ZIndex.board)
    }
    
    func cell(atRow row: Int, column: Int) -> some View {
        return BoardCellView(viewModel: viewModel.boardCellViewModels[row * 3 + column])
            .setAccessibilityIdentifier(element: .boardCell(row, column))
    }
}

#if DEBUG

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(boardSize: CGSize(width: 300, height: 300)).environmentObject(GameViewModel())
    }
}

#endif
