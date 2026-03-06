import SwiftUI

struct GameModePickerView: View {
    @Binding var selectedMode: GameMode
    @State private var isVsAI = false
    @State private var difficulty: AIDifficulty = .medium

    var body: some View {
        VStack(spacing: 16) {
            Picker("Mode", selection: $isVsAI) {
                Text("2 Players").tag(false)
                Text("vs AI").tag(true)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: LayoutConstants.isPad ? 350 : 250)

            if isVsAI {
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(AIDifficulty.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: LayoutConstants.isPad ? 350 : 250)
            }
        }
        .onChange(of: isVsAI) { _, newValue in
            selectedMode = newValue ? .vsAI(difficulty) : .localMultiplayer
        }
        .onChange(of: difficulty) { _, newValue in
            if isVsAI {
                selectedMode = .vsAI(newValue)
            }
        }
    }
}
