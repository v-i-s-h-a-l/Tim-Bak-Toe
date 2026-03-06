import SwiftUI

struct GreenButton: View {
    let title: String
    let action: () -> Void

    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)
    private var shadowSize: CGFloat { LayoutConstants.isPad ? 5.0 : 2.0 }
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
                .foregroundStyle(.white)
                .padding(LayoutConstants.isPad ? 30 : 15)
                .padding([.leading, .trailing], padding)
        }
        .background(linearGradient)
        .clipShape(.rect(cornerRadius: 60.0))
        .shadow(color: Theme.Col.shadowCasted, radius: shadowSize, x: shadowSize, y: shadowSize)
        .padding(.bottom)
    }
}
