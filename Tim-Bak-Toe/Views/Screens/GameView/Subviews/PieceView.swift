//
//  PieceView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

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

struct XGradientShape: View {

    let gradient: LinearGradient
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            DiagonalLineShape(lineWidth: 10, insetAmount: 25, isFromBottomLeftCorner: false)
            .fill(gradient)

            DiagonalLineShape(lineWidth: 10, insetAmount: 25, isFromBottomLeftCorner: true)
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

struct PieceView: View {
    
    @ObservedObject var viewModel: PieceViewModel
    var size: CGSize

    var body: some View {
        let value = viewModel.disabled ? 0.0 : viewModel.shadowRadius
        return ZStack {
            Circle()
                .fill(Theme.Col.piece)
                .shadow(color: Theme.Col.lightSource, radius: value, x: -value, y: -value)
                .shadow(color: Theme.Col.shadowCasted, radius: value, x: value, y: value)
                .animation(Animation.default)
                .blur(radius: 1)
            Circle()
                .fill(Theme.Col.piece)
            if viewModel.zIndex == ZIndex.playerPieceDragged || viewModel.disabled {
                Circle()
                    .fill(LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted))
            }
            if !viewModel.disabled {
                Circle()
                    .stroke(LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted), lineWidth: value / 2.0)
                    .blur(radius: value / 2.0)
            }
            if viewModel.style == .O {
                Circle()
                    .inset(by: 25)
                    .stroke(viewModel.style.pieceGradient, lineWidth: 9)
            } else {
                XGradientShape(gradient: viewModel.style.pieceGradient, lineWidth: 10)
            }
        }
        .zIndex(viewModel.zIndex)
        .frame(width: size.width, height: size.height)
        .offset(viewModel.relativeOffset)
        .gesture(
            DragGesture(coordinateSpace: .global)
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
