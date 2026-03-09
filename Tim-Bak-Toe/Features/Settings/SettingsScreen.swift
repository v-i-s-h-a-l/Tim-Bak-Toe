import SwiftUI

struct SettingsScreen: View {
    @Bindable var settingsViewModel: SettingsViewModel
    let onBack: () -> Void

    @Environment(\.colorScheme) var colorScheme
    @State private var appeared = false

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .ignoresSafeArea()

            VStack {
                Group {
                    Spacer()
                    GlassEffectContainer {
                        VStack(spacing: 8) {
                            SocialButton(contributor: .akb)
                            SocialButton(contributor: .vishal)
                        }
                    }
                    Spacer()
                }
                .offset(y: appeared ? 0 : -20)
                .opacity(appeared ? 1 : 0)

                VStack(spacing: 20) {
                    Picker(selection: $settingsViewModel.colorSchemeSetting, label: Text("Appearance")) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .controlSize(LayoutConstants.isPad ? .large : .regular)
                    .frame(maxWidth: LayoutConstants.isPad ? 500 : 250)

                    HStack {
                        Image(systemName: settingsViewModel.soundOn ? "speaker.2.fill" : "speaker.slash.fill")
                            .font(LayoutConstants.isPad ? .title : .body)
                            .foregroundStyle(.primary)
                            .contentTransition(.symbolEffect(.replace))
                        Spacer()
                        Toggle("", isOn: $settingsViewModel.soundOn)
                            .labelsHidden()
                    }
                    .frame(maxWidth: LayoutConstants.isPad ? 500 : 250)

                    HStack {
                        Text("\(Int(settingsViewModel.timerDuration)) seconds")
                            .font(LayoutConstants.isPad ? .title : .body)
                            .contentTransition(.numericText())
                        Spacer()
                        Stepper("", value: $settingsViewModel.timerDuration, in: 3.0...10.0)
                            .labelsHidden()
                    }
                    .frame(maxWidth: LayoutConstants.isPad ? 500 : 250)
                }
                .padding(24)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .padding(.horizontal, 24)
                .scaleEffect(appeared ? 1 : 0.95)
                .opacity(appeared ? 1 : 0)

                Spacer()

                NeuomorphicButton(title: "Back") {
                    onBack()
                }
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
            }
        }
        .preferredColorScheme(settingsViewModel.preferredColorScheme)
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                appeared = true
            }
        }
    }
}
