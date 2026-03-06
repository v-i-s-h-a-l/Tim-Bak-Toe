import SwiftUI

struct BoardView: View {
    let boardSize: CGSize
    @Bindable var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { column in
                        BoardCellView(position: BoardPosition(row: row, column: column), viewModel: viewModel)
                    }
                }
            }
        }
        .frame(width: boardSize.width, height: boardSize.height)
        .zIndex(LayoutConstants.ZIndex.board)
    }
}
