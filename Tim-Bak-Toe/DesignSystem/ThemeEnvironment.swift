import SwiftUI

private struct ThemeProviderKey: EnvironmentKey {
    static let defaultValue: any ThemeProvider = NeumorphicTheme()
}

extension EnvironmentValues {
    var themeProvider: any ThemeProvider {
        get { self[ThemeProviderKey.self] }
        set { self[ThemeProviderKey.self] = newValue }
    }
}
