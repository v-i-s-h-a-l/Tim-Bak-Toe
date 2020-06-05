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
        let isDragged = viewModel.zIndex == ZIndex.playerPieceDragged
        let isDisabled = viewModel.disabled
        let shadowCastedRadius =  viewModel.stateMultiplier * (isDisabled ? 0.0 : size.height / 40.0)
        let lightSourceShadowRadius = (isDragged || isDisabled) ? 0.0 : size.height / 40.0
        let lightSourceShadowColor = (isDragged || isDisabled) ? Color.clear : Theme.Col.lightSource
        let blurAmount: CGFloat = 1.0
        let lineWidthForPieceSign = size.height / 9.0
        let insetAmuontForPieceSign = size.height / 3.5
    
        let pieceColor = isDragged ? Theme.Col.boardCell : Theme.Col.piece
        let pieceStrokeColor = isDragged ? LinearGradient(Theme.Col.lightSource, pieceColor, pieceColor) : LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted)
        
        let width = size.width
        let height = size.height
        
        return ZStack {
            // Bottom layer responsible for the shadow casted (the layer is not visible, just its shadow, if any, is visible
            Circle()
                .fill(Theme.Col.piece)
                .shadow(color: lightSourceShadowColor, radius: lightSourceShadowRadius, x: -lightSourceShadowRadius, y: -lightSourceShadowRadius)
                .shadow(color: Theme.Col.shadowCasted, radius: shadowCastedRadius, x: shadowCastedRadius, y: shadowCastedRadius)
                .blur(radius: blurAmount)

            // The actual color of the piece that appears
            if isDisabled {
                Circle()
                    .fill(LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted))
            }
            if !isDisabled {
                Circle()
                    .fill(pieceColor)
                Circle()
                    .stroke(pieceStrokeColor, lineWidth: shadowCastedRadius / 2.0)
                    .blur(radius: 1)
            }
            
            // X or O
            if viewModel.style == .O {
                Circle()
                    .inset(by: insetAmuontForPieceSign)
                    .stroke(viewModel.style.pieceGradient, lineWidth: lineWidthForPieceSign)
            } else {
                XGradientView(gradient: viewModel.style.pieceGradient, lineWidth: lineWidthForPieceSign, insetAmount: insetAmuontForPieceSign)
            }
        }
        .zIndex(viewModel.zIndex)
        .frame(width: width, height: height)
        .scaleEffect(viewModel.scale)
        .offset(viewModel.relativeOffset)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged(viewModel.onDragChanged)
                .onEnded(viewModel.onDragEnded))
        .allowsHitTesting(!isDisabled)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear(perform: {
                    self.viewModel.onAppear(proxy)
                })
        })
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

struct DiagonalLineShape: Shape {

    let lineWidth: CGFloat
    let insetAmount: CGFloat
    let isFromBottomLeftCorner: Bool

    func path(in rect: CGRect) -> Path {
        var points = [CGPoint]()
        if isFromBottomLeftCorner {
            points = [
                CGPoint(x: insetAmount, y: rect.maxY - insetAmount),
                CGPoint(x: insetAmount + lineWidth, y: rect.maxY - insetAmount),
                CGPoint(x: rect.maxX - insetAmount, y: insetAmount),
                CGPoint(x: rect.maxX - insetAmount - lineWidth, y: insetAmount),
            ]
        } else {
            points = [
                CGPoint(x: insetAmount, y: insetAmount),
                CGPoint(x: insetAmount + lineWidth, y: insetAmount),
                CGPoint(x: rect.maxX - insetAmount, y: rect.maxY - insetAmount),
                CGPoint(x: rect.maxX - insetAmount - lineWidth, y: rect.maxY - insetAmount),
            ]
        }

        return Path { path in
            path.move(to: points.first!)
            path.addLines(points)
            path.closeSubpath()
        }
    }
}

struct XGradientView: View {

    let gradient: LinearGradient
    let lineWidth: CGFloat
    let insetAmount: CGFloat

    var body: some View {
        ZStack {
            DiagonalLineShape(lineWidth: lineWidth, insetAmount: insetAmount, isFromBottomLeftCorner: false)
            .fill(gradient)

            DiagonalLineShape(lineWidth: lineWidth, insetAmount: insetAmount, isFromBottomLeftCorner: true)
            .fill(gradient)
        }
    }
}

enum PieceStyle: String, Codable {
    case X
    case O
    
    var colorStart: Color {
        switch self {
        case .X: return Theme.Col.redStart
        case .O: return Theme.Col.blueStart
        }
    }

    var colorEnd: Color {
        switch self {
        case .X: return Theme.Col.redEnd
        case .O: return Theme.Col.blueEnd
        }
    }

    var pieceGradient: LinearGradient {
        LinearGradient(colorStart, colorEnd, startPoint: .top, endPoint: .bottom)
    }

    var timerGradient: LinearGradient {
        LinearGradient(colorStart, colorEnd, startPoint: .leading, endPoint: .trailing)
    }
}
