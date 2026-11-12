import SwiftUI
import StoreKit

public struct KappzAboutSection: View {
    public let config: KappzConfiguration
    @Environment(\.requestReview) private var requestReview

    public init(config: KappzConfiguration = KappzConfiguration()) {
        self.config = config
    }

    public var body: some View {
        Section {
            if let count = config.recordsCount, let title = config.recordsTitle {
                HStack {
                    Label(title, systemImage: "list.number")
                    Spacer()
                    Text("\(count)")
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Label("Version", systemImage: "info.circle")
                Spacer()
                Text(config.formattedVersion)
                    .foregroundStyle(.secondary)
            }

            Link(destination: config.supportURL) {
                Label("Support", systemImage: "questionmark.circle.fill")
            }

            Button {
                requestReview()
            } label: {
                Label("Rate the App", systemImage: "star.fill")
            }

            Link(destination: config.termsURL) {
                Label("Terms & Conditions", systemImage: "doc.text.fill")
            }

            Link(destination: config.privacyURL) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }

            ForEach(config.additionalLinks) { link in
                Link(destination: link.url) {
                    Label(link.title, systemImage: link.systemImage)
                }
            }
        } header: {
            Text("About")
        } footer: {
            Text(config.copyrightText)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
