//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

enum PieceStyle: String, Codable {
    case X
    case O

    var gradientColors: [Color] {
        switch self {
        case .X: return [.yellow, .orange, .red, .red]
        case .O: return [.blue, .purple, .purple]
        }
    }
    //    }
//
//    var borderColor: Color {
//        return Color.white
//    }
//
//    var borderWidth: CGFloat {
//        return 5
}

struct PieceView: View {
    
    @ObservedObject var viewModel: PieceViewModel
    var size: CGSize

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.Col.piece)
                .shadow(color: Theme.Col.lightSource, radius: 2, x: -2, y: -2)
                .shadow(color: Theme.Col.shadowCasted, radius: 2, x: 2, y: 2)
                .blur(radius: 1)
            Circle()
                .fill(Theme.Col.piece)
            Text("\(viewModel.style.rawValue.uppercased())")
        }
        .zIndex(viewModel.zIndex)
        .frame(width: size.width, height: size.height)
        .offset(viewModel.relativeOffset)
//        .opacity(viewModel.disabled ? 0.5 : 1)
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
