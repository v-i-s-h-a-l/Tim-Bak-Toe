import SwiftUI

struct SettingsScreen: View {
    @Bindable var settingsViewModel: SettingsViewModel
    let onBack: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .ignoresSafeArea()

            VStack {
                Group {
                    Spacer()
                    VStack {
                        SocialButton(contributor: .akb)
                            .padding()
                        SocialButton(contributor: .vishal)
                    }
                    Spacer()
                }

                Picker(selection: $settingsViewModel.colorSchemeSetting, label: Text("Appearance")) {
                    Text("System").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: LayoutConstants.isPad ? 350 : 250)
                .padding()

                Group {
                    Toggle(isOn: $settingsViewModel.soundOn) {
                        Image(systemName: settingsViewModel.soundOn ? "speaker.2.fill" : "speaker.slash.fill")
                            .font(LayoutConstants.isPad ? .title : .body)
                            .foregroundStyle(.primary)
                            .padding(.trailing)
                    }
                    .padding()

                    Stepper(value: $settingsViewModel.timerDuration, in: 3.0...10.0) {
                        VStack {
                            Text("\(Int(settingsViewModel.timerDuration)) seconds")
                                .font(LayoutConstants.isPad ? .title : .body)
                        }
                        .padding(.trailing)
                    }
                    .padding()
                }
                .frame(maxWidth: LayoutConstants.isPad ? 350 : 250)
                .padding()

                Spacer()

                NeuomorphicButton(title: "Back") {
                    onBack()
                }
            }
        }
        .preferredColorScheme(settingsViewModel.preferredColorScheme)
    }
}
