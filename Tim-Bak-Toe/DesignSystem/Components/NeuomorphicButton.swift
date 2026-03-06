import SwiftUI

struct NeuomorphicButton: View {
    let title: String
    let action: () -> Void

    private var padding: CGFloat { LayoutConstants.isPad ? 120 : 60 }

    var body: some View {
        Button(action: {
            action()
            Sound.tap.play()
        }) {
            Text(title)
                .font(LayoutConstants.isPad ? .title : .body)
                .kerning(2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(LayoutConstants.isPad ? 30 : 15)
                .padding([.leading, .trailing], padding)
        }
        .glassEffect(.regular.interactive(), in: .capsule)
        .padding(.bottom)
    }
}
