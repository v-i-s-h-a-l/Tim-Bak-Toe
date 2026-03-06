import SwiftUI

struct TimerBarView: View {
    let timer: TurnTimer
    let style: PieceStyle
    let isRightEdged: Bool

    @State private var barSize: CGSize = .zero

    var body: some View {
        let cornerRadius = barSize.height / 2

        ZStack {
            Rectangle()
                .fill(Theme.Col.boardCell)
                .clipShape(.rect(cornerRadius: cornerRadius))
                .frame(width: barSize.width)
                .overlay(
                    Rectangle()
                        .stroke(
                            LinearGradient(
                                Theme.Col.shadowCasted, Theme.Col.lightSource,
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .clipShape(.rect(cornerRadius: cornerRadius))
                )

            HStack {
                if isRightEdged { Spacer(minLength: 0) }

                style.timerGradient
                    .clipShape(.rect(cornerRadius: cornerRadius))
                    .frame(width: barSize.width * CGFloat(timer.fillRatio))
                    .animation(.linear(duration: 0.15), value: timer.fillRatio)

                if !isRightEdged { Spacer(minLength: 0) }
            }
        }
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear { barSize = proxy.frame(in: .local).size }
        })
    }
}
