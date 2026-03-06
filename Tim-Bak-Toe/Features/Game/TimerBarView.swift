import SwiftUI

struct TimerBarView: View {
    let timer: TurnTimer
    let style: PieceStyle
    let isRightEdged: Bool

    @State private var barSize: CGSize = .zero

    var body: some View {
        let cornerRadius = barSize.height / 2

        ZStack {
            Capsule()
                .fill(.clear)
                .glassEffect(.regular, in: .capsule)
                .frame(width: barSize.width)

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
