import SwiftUI

extension View {
    func enableSwipeBack() -> some View {
        #if os(iOS)
        background {
            SwipeBackHelper()
        }
        #else
        self
        #endif
    }
}

#if os(iOS)
import UIKit

private struct SwipeBackHelper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        SwipeBackViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class SwipeBackViewController: UIViewController {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
#endif
