import SwiftUI

struct HomeScreen: View {
    let onPlay: (GameMode) -> Void
    let onSettings: () -> Void

    @State private var gameMode: GameMode = .localMultiplayer

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
                    HStack {
                        Text("Grab a friend to play")
                            .font(LayoutConstants.isPad ? .title : .body)
                            .kerning(1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                .padding(.leading, LayoutConstants.isPad ? 160 : 40)

                Spacer()

                GameModePickerView(selectedMode: $gameMode)
                    .padding()

                Spacer()

                GreenButton(title: "Play Now") {
                    onPlay(gameMode)
                }
                .padding(.top)

                NeuomorphicButton(title: "Settings") {
                    onSettings()
                }
                .padding(.bottom)
            }
        }
    }
}
