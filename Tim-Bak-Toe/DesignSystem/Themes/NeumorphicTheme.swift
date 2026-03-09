import SwiftUI

struct NeumorphicTheme: ThemeProvider {
    var backgroundColor: Color { Theme.Col.gameBackground }
    var overlayBackdropColor: Color { Color.black.opacity(0.3) }

    func pieceBottomLayer(state: PieceViewState, size: CGSize) -> AnyView {
        AnyView(state.bottomShadowLayer(pieceSize: size))
    }

    func pieceUpperLayer(state: PieceViewState, size: CGSize, style: PieceStyle) -> AnyView {
        AnyView(
            Group {
                state.upperFillLayer(pieceSize: size)
                style.overlay(forSize: size)
            }
        )
    }

    func winParticles(winner: Player?) -> AnyView {
        guard winner != nil else { return AnyView(EmptyView()) }
        return AnyView(NeumorphicConfettiView())
    }

    func dragSquishScale() -> CGSize { CGSize(width: 1, height: 1) }
    func dragRotation(velocityX: CGFloat) -> Double { 0 }
    func placeBounceKeyframes() -> [CGSize] { [] }

    func wonAnimation() -> Animation {
        Animation.easeInOutBack.repeatForever(autoreverses: true)
    }

    func wonBounceDelay(pieceIndex: Int) -> Double { 0 }
    func wonBounceOffset(for size: CGSize) -> CGFloat { 0 }
}

struct ConfettiParticle: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    var offset: CGSize
    var opacity: Double
}

private struct NeumorphicConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        ForEach(particles) { particle in
            Circle()
                .fill(particle.color)
                .frame(width: particle.size, height: particle.size)
                .offset(particle.offset)
                .opacity(particle.opacity)
        }
        .onAppear { spawnConfetti() }
    }

    private func spawnConfetti() {
        let colors: [Color] = [
            Theme.Col.redStart, Theme.Col.redEnd,
            Theme.Col.blueStart, Theme.Col.blueEnd,
            Theme.Col.greenStart, Theme.Col.greenEnd,
            .yellow, .purple, .orange
        ]

        for i in 0..<40 {
            particles.append(ConfettiParticle(
                id: i,
                color: colors.randomElement()!,
                size: CGFloat.random(in: 6...14),
                offset: .zero,
                opacity: 1
            ))
        }

        withAnimation(.easeOut(duration: 1.5)) {
            for i in particles.indices {
                particles[i].offset = CGSize(
                    width: CGFloat.random(in: -200...200),
                    height: CGFloat.random(in: -400...100)
                )
            }
        }

        withAnimation(.easeIn(duration: 0.8).delay(1.0)) {
            for i in particles.indices {
                particles[i].opacity = 0
            }
        }
    }
}
