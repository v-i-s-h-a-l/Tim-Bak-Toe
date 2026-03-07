import SwiftUI

struct CountdownOverlayView: View {
    let onComplete: () -> Void

    @State private var currentValue = 3
    @State private var showValue = false
    @State private var finished = false

    var body: some View {
        ZStack {
            Color.black.opacity(finished ? 0 : 0.3)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.3), value: finished)

            if !finished {
                Text(displayText)
                    .font(.system(size: 96, weight: .black, design: .rounded))
                    .kerning(4)
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(countsDown: true))
                    .scaleEffect(showValue ? 1 : 2)
                    .opacity(showValue ? 1 : 0)
                    .animation(.spring(duration: 0.4, bounce: 0.3), value: showValue)
                    .animation(.spring(duration: 0.4, bounce: 0.3), value: currentValue)
            }
        }
        .allowsHitTesting(!finished)
        .onAppear {
            startCountdown()
        }
    }

    private var displayText: String {
        currentValue > 0 ? "\(currentValue)" : "Go!"
    }

    private func startCountdown() {
        // Show "3"
        withAnimation {
            showValue = true
        }

        // "2" at 0.8s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                currentValue = 2
            }
        }

        // "1" at 1.6s
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation {
                currentValue = 1
            }
        }

        // "Go!" at 2.4s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation {
                currentValue = 0
            }
        }

        // Dismiss at 3.2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation {
                finished = true
            }
            onComplete()
        }
    }
}
