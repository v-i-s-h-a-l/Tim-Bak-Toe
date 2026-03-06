import SwiftUI

struct BoardCellView: View {
    let position: BoardPosition
    @Bindable var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.Col.boardCell)
            Circle()
                .stroke(
                    LinearGradient(Theme.Col.shadowCasted, Theme.Col.lightSource),
                    lineWidth: LayoutConstants.isPad ? 6 : 3
                )
        }
        .padding(LayoutConstants.cellPadding)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear {
                    viewModel.cellAppeared(at: position, frame: proxy.frame(in: .global))
                }
        })
        .setAccessibilityIdentifier(element: .boardCell(position.row, position.column))
    }
}
