//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PieceView: View {
    
    @Binding var zIndexOfContainer: Double
    @ObservedObject var viewModel: PieceViewModel
    var size: CGSize

    @State private var scale: CGFloat = 1.0
    @State private var zIndex: Double = ZIndex.playerPiecePlaced

    var body: some View {        
        ZStack {
            viewModel.pieceState.bottomShadowLayer(pieceSize: size)
            viewModel.pieceState.upperFillLayer(pieceSize: size)
            
            // X or O
            viewModel.style.overlay(forSize: size)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(scale)
        .offset(viewModel.relativeOffset)
        .zIndex(zIndex)
        .allowsHitTesting(viewModel.pieceState.allowsHitTesting)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear(perform: {
                    self.viewModel.onAppear(proxy)})})
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged(viewModel.onDragChanged)
                .onEnded(viewModel.onDragEnded))
        .onReceive(viewModel.$pieceState.eraseToAnyPublisher()) { state in
            DispatchQueue.main.async {
                self.handleStateUpdate(for: state)
            }
        }
    }

    private func handleStateUpdate(for state: PieceViewState) {
        let animation = state == .won ? Animation.easeInOutBack.repeatForever(autoreverses: true) : Animation.default
        withAnimation(animation) {
            self.scale = state.scale
        }
        let delay = state == .dragged ? 0.0 : 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.zIndex = state.zIndex
            self.zIndexOfContainer = state.zIndex
        }
//        if state == .dragged {
//            self.zIndex = state.zIndex
//            self.zIndexOfContainer = state.zIndex
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.zIndex = state.zIndex
//                self.zIndexOfContainer = state.zIndex
//            }
//        }
    }
}

//#if DEBUG
//
//struct PieceView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            PieceView(viewModel: PieceViewModel(with: .X), size: CGSize(width: 80, height: 80))
//            PieceView(viewModel: PieceViewModel(with: .O), size: CGSize(width: 80, height: 80))
//                .colorScheme(.dark)
//        }
//    }
//}
//
//#endif
