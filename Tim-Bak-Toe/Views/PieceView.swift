//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

enum PieceStyle: String, Codable {
    case circle1
    case circle2

    var gradientColors: [Color] {
        switch self {
        case .circle1: return [.yellow, .orange, .red, .red]
        case .circle2: return [.blue, .purple, .purple]
        }
    }

    var borderColor: Color {
        return Color.white
    }

    var borderWidth: CGFloat {
        return 5
    }
}

struct PieceView: View {
    
    @ObservedObject var viewModel: PieceViewModel
    var size: CGSize = CGSize(width: 50, height: 50)

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: viewModel.style.gradientColors), center: .center, startRadius: 0, endRadius: size.height * 0.8))
            
            Circle()
                .stroke(viewModel.style.borderColor, lineWidth: viewModel.style.borderWidth)
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
//
//struct PieceView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieceView()
//    }
//}
