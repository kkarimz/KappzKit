import SwiftUI

public struct KappzAboutView: View {
    public let config: KappzConfiguration
    @Environment(\.dismiss) private var dismiss

    public init(config: KappzConfiguration = KappzConfiguration()) {
        self.config = config
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "app.badge.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.accentColor)
                            .padding(.top, 8)
                        Text(config.appName)
                            .font(.title2.bold())
                        Text("Version \(config.formattedVersion)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                KappzAboutSection(config: config)
            }
            .navigationTitle("About")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
