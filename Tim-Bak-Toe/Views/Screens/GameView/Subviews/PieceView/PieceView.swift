//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PieceView: View {
    
    @ObservedObject var viewModel: PieceViewModel
    var size: CGSize
    
    var body: some View {        
        return ZStack {
            viewModel.pieceState.bottomShadowLayer(pieceSize: size)
            viewModel.pieceState.upperFillLayer(pieceSize: size)
            
            // X or O
            viewModel.style.overlay(forSize: size)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(viewModel.pieceState.scale)
        .offset(viewModel.relativeOffset)
        .zIndex(viewModel.pieceState.zIndex)
        .allowsHitTesting(viewModel.pieceState.allowsHitTesting)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear(perform: {
                    self.viewModel.onAppear(proxy)})})
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged(viewModel.onDragChanged)
                .onEnded(viewModel.onDragEnded))
    }
}

#if DEBUG

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PieceView(viewModel: PieceViewModel(with: .X), size: CGSize(width: 80, height: 80))
            PieceView(viewModel: PieceViewModel(with: .O), size: CGSize(width: 80, height: 80))
                .colorScheme(.dark)
        }
    }
}

#endif
