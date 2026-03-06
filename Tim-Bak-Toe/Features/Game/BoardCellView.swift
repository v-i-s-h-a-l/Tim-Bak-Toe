import SwiftUI

struct BoardCellView: View {
    let position: BoardPosition
    @Bindable var viewModel: GameViewModel

    var body: some View {
        Circle()
            .fill(.clear)
            .glassEffect(.regular, in: .circle)
            .padding(LayoutConstants.cellPadding)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { frame in
                viewModel.cellAppeared(at: position, frame: frame)
            }
            .setAccessibilityIdentifier(element: .boardCell(position.row, position.column))
    }
}
