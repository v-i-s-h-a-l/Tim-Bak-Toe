import SwiftUI

private enum ModeCategory: Int, CaseIterable {
    case local = 0
    case ai = 1
    case online = 2

    var label: String {
        switch self {
        case .local: "2 Players"
        case .ai: "vs AI"
        case .online: "Online"
        }
    }
}

struct GameModePickerView: View {
    @Binding var selectedMode: GameMode
    @State private var category: ModeCategory = .local
    @State private var difficulty: AIDifficulty = .medium

    private var isAuthenticated: Bool {
        GameCenterManager.shared.isAuthenticated
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Mode", selection: $category) {
                ForEach(ModeCategory.allCases, id: \.self) { mode in
                    Text(mode.label).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(LayoutConstants.isPad ? .large : .regular)

            .frame(maxWidth: LayoutConstants.isPad ? 500 : 250)

            if category == .ai {
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(AIDifficulty.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .controlSize(LayoutConstants.isPad ? .large : .regular)
    
                .frame(maxWidth: LayoutConstants.isPad ? 500 : 250)
                .transition(.scale.combined(with: .opacity))
            }

            if category == .online && !isAuthenticated {
                Text("Sign in to Game Center to play online")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.4, bounce: 0.3), value: category)
        .onChange(of: category) { _, newValue in
            switch newValue {
            case .local: selectedMode = .localMultiplayer
            case .ai: selectedMode = .vsAI(difficulty)
            case .online: selectedMode = .onlineMultiplayer
            }
        }
        .onChange(of: difficulty) { _, newValue in
            if category == .ai {
                selectedMode = .vsAI(newValue)
            }
        }
    }
}
