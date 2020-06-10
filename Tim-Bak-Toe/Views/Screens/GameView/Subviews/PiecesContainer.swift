//
//  PiecesContainer.swift
//  XO3
//
//  Created by Vishal Singh on 10/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PiecesContainer: View {
    
    let pieceSize: CGSize
    let pieces: [PieceViewModel]

    @State private var zIndex: Double = ZIndex.playerPiecePlaced

    var body: some View {
        let spacingForPieces = pieceSize.height / 5.0

        return HStack(spacing: spacingForPieces) {
            ForEach(0..<pieces.count) { index in
                PieceView(zIndexOfContainer: self.$zIndex, viewModel: self.pieces[index], size: self.pieceSize)
                    .setAccessibilityIdentifier(element: self.pieces[index].style.accessibilityElement(for: index))
            }
        }
        .zIndex(zIndex)
    }
}
