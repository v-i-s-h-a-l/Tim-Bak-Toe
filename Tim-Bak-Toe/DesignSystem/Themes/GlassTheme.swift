import SwiftUI

struct GlassTheme: ThemeProvider {
    // Deep navy background
    var backgroundColor: Color { Color(red: 0.051, green: 0.067, blue: 0.090) }
    var overlayBackdropColor: Color { Color.black.opacity(0.5) }

    static let xColor = Color(red: 0.941, green: 0.400, blue: 0.188) // #F06630
    static let oColor = Color(red: 0.231, green: 0.608, blue: 0.969) // #3B9BF7

    static func pieceColor(for style: PieceStyle) -> Color {
        style == .X ? xColor : oColor
    }

    func pieceBottomLayer(state: PieceViewState, size: CGSize) -> AnyView {
        AnyView(Color.clear)
    }

    func pieceUpperLayer(state: PieceViewState, size: CGSize, style: PieceStyle) -> AnyView {
        AnyView(JellyBubbleView(style: style, size: size))
    }

    func winParticles(winner: Player?) -> AnyView {
        guard let winner else { return AnyView(EmptyView()) }
        let color: Color = winner == .x ? Self.xColor : Self.oColor
        return AnyView(JellyBurstView(playerColor: color))
    }

    // Vertical stretch: feels like pulling a sphere up out of a tight hole
    func dragSquishScale() -> CGSize { CGSize(width: 0.88, height: 1.12) }

    // Lean in the direction of horizontal movement — creates sphere-rolling-on-surface illusion
    func dragRotation(velocityX: CGFloat) -> Double {
        let clamped = max(-1200, min(1200, Double(velocityX)))
        return clamped * 0.016 // max ±19.2° at ±1200 pts/s
    }

    // Just the impact flatten — the spring back is handled by PieceView with high bounce
    func placeBounceKeyframes() -> [CGSize] {
        [CGSize(width: 1.38, height: 0.62)]
    }

    func wonAnimation() -> Animation {
        .spring(duration: 0.4, bounce: 0.7).repeatForever(autoreverses: true)
    }

    func wonBounceDelay(pieceIndex: Int) -> Double {
        Double(pieceIndex) * 0.08
    }

    func wonBounceOffset(for size: CGSize) -> CGFloat {
        -size.height * 0.3
    }
}

private struct JellyBubbleView: View {
    let style: PieceStyle
    let size: CGSize

    private var color: Color { GlassTheme.pieceColor(for: style) }

    var body: some View {
        ZStack {
            // 1. Translucent jelly body
            Circle()
                .fill(color.opacity(0.35))

            // 2. Radial inner glow (wet look)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [color.opacity(0.6), Color.clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size.width * 0.3
                    )
                )

            // 3. Specular highlight (upper-left)
            Ellipse()
                .fill(Color.white.opacity(0.8))
                .frame(width: size.width * 0.3, height: size.height * 0.18)
                .offset(x: -size.width * 0.12, y: -size.height * 0.22)

            // 4. X/O symbol with player color
            style.overlay(forSize: size)
                .colorMultiply(color)

            // 5. Bubble rim
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        }
    }
}

private struct JellyBurstView: View {
    let playerColor: Color

    @State private var burst = false
    @State private var visible = true

    var body: some View {
        ZStack {
            if visible {
                ForEach(0..<24, id: \.self) { i in
                    let angle = Double(i) / 24.0 * 360.0
                    let radians = angle * .pi / 180.0
                    let distance: CGFloat = burst ? 180 : 0

                    Capsule()
                        .fill(playerColor.opacity(Double.random(in: 0.6...1.0)))
                        .frame(width: 6, height: 14)
                        .offset(
                            x: cos(radians) * distance,
                            y: sin(radians) * distance
                        )
                        .rotationEffect(.degrees(angle + 90))
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                burst = true
            }
            withAnimation(.spring().delay(0.4)) {
                visible = false
            }
        }
    }
}
