import SwiftUI

enum PieceStyle: String, Codable, Sendable {
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
        switch self {
        case .X:
            return LinearGradient(colorStart, colorEnd, startPoint: .leading, endPoint: .trailing)
        case .O:
            return LinearGradient(colorEnd, colorStart, startPoint: .leading, endPoint: .trailing)
        }
    }

    func overlay(forSize size: CGSize) -> some View {
        let lineWidthForPieceSign = size.height / 11.0
        let scale: CGFloat = 3.0 / 7.0
        let insetAmount = size.height / 3.5

        return Group {
            if self == .O {
                Circle()
                    .inset(by: insetAmount)
                    .stroke(pieceGradient, lineWidth: lineWidthForPieceSign)
            }
            if self == .X {
                XGradientView(gradient: pieceGradient, lineWidth: lineWidthForPieceSign / scale)
                    .scaleEffect(scale, anchor: .center)
            }
        }
    }

    static func from(player: Player) -> PieceStyle {
        switch player {
        case .x: return .X
        case .o: return .O
        }
    }
}

struct XGradientView: View {
    let gradient: LinearGradient
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            DiagonalLineShape(lineWidth: lineWidth, isFromBottomLeftCorner: false, insetAmount: 0)
                .fill(gradient)
            DiagonalLineShape(lineWidth: lineWidth, isFromBottomLeftCorner: true, insetAmount: 0)
                .fill(gradient)
        }
    }
}
