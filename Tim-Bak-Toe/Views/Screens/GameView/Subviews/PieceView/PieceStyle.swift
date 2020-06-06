//
//  PieceStyle.swift
//  XO3
//
//  Created by Vishal Singh on 06/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Foundation
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

    func overlay(forSize size: CGSize) -> some View {
        let lineWidthForPieceSign = size.height / 9.0
        let insetAmuontForPieceSign = size.height / 3.5

        return Group {
            if self == .O {
                Circle()
                    .inset(by: insetAmuontForPieceSign)
                    .stroke(pieceGradient, lineWidth: lineWidthForPieceSign)
            }
            if self == .X {
                XGradientView(gradient: pieceGradient, lineWidth: lineWidthForPieceSign, insetAmount: insetAmuontForPieceSign)
            }
        }
    }
}
