import SwiftUI

struct WinnerOverlayView: View {
    let winner: Player?
    let onRestart: () -> Void
    let onHome: () -> Void

    @State private var showContent = false
    @State private var confettiParticles: [ConfettiParticle] = []

    var body: some View {
        ZStack {
            // Dimming backdrop
            Color.black.opacity(showContent ? 0.3 : 0)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 0.3), value: showContent)

            // Confetti
            ForEach(confettiParticles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(particle.offset)
                    .opacity(particle.opacity)
            }

            // Glass card
            VStack(spacing: 24) {
                Text(winnerText)
                    .font(LayoutConstants.isPad ? .largeTitle : .title)
                    .fontWeight(.heavy)
                    .kerning(3)
                    .foregroundStyle(.primary)

                VStack(spacing: 12) {
                    GreenButton(title: "Restart", action: onRestart)
                    GreenButton(title: "Home", action: onHome)
                }
            }
            .padding(32)
            .glassEffect(.clear, in: .rect(cornerRadius: 32))
            .scaleEffect(showContent ? 1 : 0.5)
            .opacity(showContent ? 1 : 0)
            .animation(.spring(duration: 0.5, bounce: 0.4), value: showContent)
        }
        .onAppear {
            showContent = true
            if winner != nil {
                spawnConfetti()
            }
        }
    }

    private var winnerText: String {
        if let winner {
            return "\(winner == .x ? "X" : "O") Wins!"
        }
        return "Draw!"
    }

    private func spawnConfetti() {
        let colors: [Color] = [
            Theme.Col.redStart, Theme.Col.redEnd,
            Theme.Col.blueStart, Theme.Col.blueEnd,
            Theme.Col.greenStart, Theme.Col.greenEnd,
            .yellow, .purple, .orange
        ]

        for i in 0..<40 {
            let particle = ConfettiParticle(
                id: i,
                color: colors.randomElement()!,
                size: CGFloat.random(in: 6...14),
                offset: .zero,
                opacity: 1
            )
            confettiParticles.append(particle)
        }

        // Animate particles outward
        withAnimation(.easeOut(duration: 1.5)) {
            for i in confettiParticles.indices {
                confettiParticles[i].offset = CGSize(
                    width: CGFloat.random(in: -200...200),
                    height: CGFloat.random(in: -400...100)
                )
            }
        }

        // Fade out
        withAnimation(.easeIn(duration: 0.8).delay(1.0)) {
            for i in confettiParticles.indices {
                confettiParticles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    var offset: CGSize
    var opacity: Double
}
