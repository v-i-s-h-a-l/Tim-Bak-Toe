//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PieceView: View {
    
    @ObservedObject var viewModel = PieceViewModel()
    var size: CGSize = CGSize(width: 50, height: 50)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [.yellow, .orange, .red, .red]), center: .center, startRadius: 0, endRadius: size.height * 0.8))
            
            Circle()
                .stroke(Theme.Col.pieceBorder, lineWidth: 4)
        }
        .zIndex(viewModel.isDragStarted ? ZIndex.playerPieceDragged : ZIndex.playerPiecePlaced)
        .frame(width: size.width, height: size.height)
        .offset(viewModel.relativeOffset)
        .opacity(viewModel.disabled ? 0.5 : 1)
        .gesture(DragGesture(coordinateSpace: .global)
        .onChanged(viewModel.onDragChanged)
        .onEnded(viewModel.onDragEnded))
        .allowsHitTesting(!viewModel.disabled)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear(perform: {
                    self.viewModel.onAppear(proxy)
                })
        })
    }
    
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView()
    }
}
