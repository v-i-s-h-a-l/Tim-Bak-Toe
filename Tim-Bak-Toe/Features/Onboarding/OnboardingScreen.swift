import SwiftUI

struct OnboardingScreen: View {
    let onPlay: () -> Void

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

                    Spacer()

                    Image(systemName: "person.2")
                        .font(.system(size: LayoutConstants.isPad ? 150 : 100, weight: LayoutConstants.isPad ? .semibold : .medium))
                        .foregroundStyle(.gray)

                    Spacer()

                    Text("Tic Tac Toe")
                        .font(LayoutConstants.isPad ? .largeTitle : .title)
                        .fontWeight(.bold)
                        .kerning(2)
                        .foregroundStyle(.primary)

                    Spacer()
                }

                Group {
                    Text("Welcome to Tic Tac Toe\nwith a twist.\nThe turns are timed and\nyou are limited to three pieces each.\n\nGrab a friend to play")
                        .font(LayoutConstants.isPad ? .title : .body)
                        .kerning(1)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    Spacer()
                    Spacer()

                    GreenButton(title: "Play Now") {
                        onPlay()
                    }

                    Spacer()
                    Spacer()
                }
            }
        }
    }
}
