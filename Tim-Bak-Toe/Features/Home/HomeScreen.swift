import SwiftUI

struct HomeScreen: View {
    let onPlay: (GameMode) -> Void
    let onSettings: () -> Void

    @State private var gameMode: GameMode = .localMultiplayer
    @State private var logoAppeared = false
    @State private var contentAppeared = false

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .ignoresSafeArea()

            VStack {
                Group {
                    HStack {
                        Image(decorative: "XO3")
                            .renderingMode(.original)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                            .scaleEffect(logoAppeared ? 1 : 0.3)
                            .opacity(logoAppeared ? 1 : 0)
                        Spacer()
                    }
                    HStack {
                        Text("Tic Tac Toe")
                            .font(LayoutConstants.isPad ? .largeTitle : .title)
                            .fontWeight(.bold)
                            .kerning(2)
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .offset(y: contentAppeared ? 0 : 20)
                    .opacity(contentAppeared ? 1 : 0)

                    HStack {
                        Text("Grab a friend to play")
                            .font(LayoutConstants.isPad ? .title : .body)
                            .kerning(1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .offset(y: contentAppeared ? 0 : 20)
                    .opacity(contentAppeared ? 1 : 0)
                }
                .padding(.leading, LayoutConstants.isPad ? 160 : 40)

                Spacer()

                GameModePickerView(selectedMode: $gameMode)
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 24)
                    .scaleEffect(contentAppeared ? 1 : 0.9)
                    .opacity(contentAppeared ? 1 : 0)

                Spacer()

                GlassEffectContainer {
                    VStack(spacing: 8) {
                        GreenButton(title: "Play Now") {
                            onPlay(gameMode)
                        }

                        NeuomorphicButton(title: "Settings") {
                            onSettings()
                        }
                    }
                }
                .offset(y: contentAppeared ? 0 : 40)
                .opacity(contentAppeared ? 1 : 0)
                .padding(.bottom)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7, bounce: 0.5)) {
                logoAppeared = true
            }
            withAnimation(.spring(duration: 0.6, bounce: 0.3).delay(0.2)) {
                contentAppeared = true
            }
        }
    }
}
