import SwiftUI

struct OnboardingScreen: View {
    let onPlay: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .ignoresSafeArea()

            VStack {
                Group {
                    HStack {
                        Image("XO3")
                            .renderingMode(.original)
                        Spacer()
                    }
                    .padding(40)
                    .scaleEffect(appeared ? 1 : 0.3)
                    .opacity(appeared ? 1 : 0)

                    Spacer()

                    Image(systemName: "person.2")
                        .font(.system(size: LayoutConstants.isPad ? 150 : 100, weight: LayoutConstants.isPad ? .semibold : .medium))
                        .foregroundStyle(.gray)
                        .symbolEffect(.bounce, value: appeared)

                    Spacer()

                    Text("Tic Tac Toe")
                        .font(LayoutConstants.isPad ? .largeTitle : .title)
                        .fontWeight(.bold)
                        .kerning(2)
                        .foregroundStyle(.primary)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)

                    Spacer()
                }

                Group {
                    Text("Welcome to Tic Tac Toe\nwith a twist.\nThe turns are timed and\nyou are limited to three pieces each.\n\nGrab a friend to play")
                        .font(LayoutConstants.isPad ? .title : .body)
                        .kerning(1)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 20)
                        .glassEffect(.regular, in: .rect(cornerRadius: 20))
                        .padding(.horizontal, 24)
                        .offset(y: appeared ? 0 : 30)
                        .opacity(appeared ? 1 : 0)

                    Spacer()
                    Spacer()

                    GreenButton(title: "Play Now") {
                        onPlay()
                    }
                    .scaleEffect(appeared ? 1 : 0.8)
                    .opacity(appeared ? 1 : 0)

                    Spacer()
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8, bounce: 0.4).delay(0.1)) {
                appeared = true
            }
        }
    }
}
