import SwiftUI

struct WinnerOverlayView: View {
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            VStack {
                GreenButton(title: "Restart", action: onRestart)
                    .padding(.top, LayoutConstants.screenEdgePadding)

                Spacer()

                GreenButton(title: "Home", action: onHome)
                    .padding(.bottom, LayoutConstants.screenEdgePadding)
            }
        }
    }
}
