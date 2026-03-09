import SwiftUI

enum AppTheme: String, CaseIterable, Codable {
    case neumorphic = "Neumorphic"
    case glass = "Glass"

    static let defaultTheme: AppTheme = .neumorphic

    var displayName: String { rawValue }

    var provider: any ThemeProvider {
        switch self {
        case .neumorphic: return NeumorphicTheme()
        case .glass: return GlassTheme()
        }
    }
}
