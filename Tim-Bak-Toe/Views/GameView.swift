//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel = GameViewModel()
    private let size: CGSize = UIScreen.main.bounds.size

    private var boardSize: CGSize {
        CGSize(width: size.width * 0.8, height: size.width * 0.8)
    }
    
    private var pieceSize: CGSize {
        CGSize(width: size.width * 0.8 / (3 * 1.4), height: size.width * 0.8 / (3 * 1.4))
    }
    
    var body: some View {
        ZStack {
            Theme.Col.gameBackground
            VStack {
                Spacer()
                GridStack(rows: 3, columns: 3, content: cell)
                    .frame(width: size.width * 0.8, height: size.width * 0.8)
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    ForEach(viewModel.hostPieces) {
                        PieceView(viewModel: $0, size: self.pieceSize)
                    }
                    .padding([.bottom])
                    .padding([.bottom])
                }
            }
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
    }

    func cell(atRow row: Int, column: Int) -> some View {
        return BoardCellView(viewModel: viewModel.boardCellViewModels[row][column])
        .padding(2)
    }
}

struct GameView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            GameView().colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: PreviewDevice.iPadPro_12_9))
            GameView().colorScheme(.light).previewDevice(PreviewDevice(rawValue: PreviewDevice.iPhoneSE))
        }
    }
}
