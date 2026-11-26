import SwiftUI
import StoreKit

public struct KappzAboutSection: View {
    public let config: KappzConfiguration
    @Environment(\.requestReview) private var requestReview
    @State private var tipDisplayPrice: String?
    @State private var isPurchasingTip = false
    @State private var tipAlertTitle: String?
    @State private var tipAlertMessage: String?

    public init(config: KappzConfiguration = KappzConfiguration()) {
        self.config = config
    }

    private var actionLinkColor: Color {
        #if os(macOS)
        Color(nsColor: .linkColor)
        #else
        Color.accentColor
        #endif
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

            Button {
                requestReview()
            } label: {
                Label("Rate the App", systemImage: "star.fill")
                    .foregroundStyle(actionLinkColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if let tipProductID = config.tipProductID, !tipProductID.isEmpty {
                Button {
                    Task { await purchaseTip(productID: tipProductID) }
                } label: {
                    HStack {
                        Label(config.tipTitle, systemImage: config.tipSystemImage)
                            .foregroundStyle(actionLinkColor)
                        Spacer()
                        if isPurchasingTip {
                            ProgressView()
                                .controlSize(.small)
                        } else if let tipDisplayPrice {
                            Text(tipDisplayPrice)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(isPurchasingTip)
                .task(id: tipProductID) {
                    await loadTipPrice(productID: tipProductID)
                }
            }

            Link(destination: config.supportURL) {
                Label("Support", systemImage: "questionmark.circle.fill")
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
        .alert(tipAlertTitle ?? "", isPresented: Binding(
            get: { tipAlertMessage != nil },
            set: { if !$0 { tipAlertMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(tipAlertMessage ?? "")
        }
    }

    @MainActor
    private func loadTipPrice(productID: String) async {
        do {
            let products = try await Product.products(for: [productID])
            tipDisplayPrice = products.first?.displayPrice
        } catch {
            tipDisplayPrice = nil
        }
    }

    @MainActor
    private func purchaseTip(productID: String) async {
        isPurchasingTip = true
        defer { isPurchasingTip = false }
        do {
            let products = try await Product.products(for: [productID])
            guard let product = products.first else {
                tipAlertTitle = "Unavailable"
                tipAlertMessage = "Tip option is not available right now. Please try again later."
                return
            }
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    tipAlertTitle = "Thank You!"
                    tipAlertMessage = "Thanks for supporting \(config.appName)!"
                } else {
                    tipAlertTitle = "Verification Failed"
                    tipAlertMessage = "Your purchase could not be verified."
                }
            case .pending:
                tipAlertTitle = "Purchase Pending"
                tipAlertMessage = "Your purchase is waiting for approval."
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            tipAlertTitle = "Purchase Failed"
            tipAlertMessage = error.localizedDescription
        }
    }
}
