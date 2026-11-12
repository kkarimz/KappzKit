import Foundation

public struct KappzLinkItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let systemImage: String
    public let url: URL

    public init(id: String = UUID().uuidString, title: String, systemImage: String, url: URL) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.url = url
    }
}

public struct KappzConfiguration: Sendable {
    public var appName: String
    public var appVersion: String
    public var buildNumber: String
    public var supportURL: URL
    public var termsURL: URL
    public var privacyURL: URL
    public var companyName: String
    public var recordsTitle: String?
    public var recordsCount: Int?
    public var additionalLinks: [KappzLinkItem]

    public var formattedVersion: String {
        "\(appVersion) (\(buildNumber))"
    }

    public var copyrightText: String {
        let year = Calendar.current.component(.year, from: Date())
        return "© \(year) \(companyName)"
    }

    public init(
        appName: String? = nil,
        appVersion: String? = nil,
        buildNumber: String? = nil,
        supportURL: URL = URL(string: "https://kappz.net/contact.html")!,
        termsURL: URL = URL(string: "https://kappz.net/terms.html")!,
        privacyURL: URL = URL(string: "https://kappz.net/privacy.html")!,
        companyName: String = "Kappz LLC",
        recordsTitle: String? = "Total Logs",
        recordsCount: Int? = nil,
        additionalLinks: [KappzLinkItem] = []
    ) {
        let bundle = Bundle.main
        self.appName = appName
            ?? (bundle.infoDictionary?["CFBundleDisplayName"] as? String)
            ?? (bundle.infoDictionary?["CFBundleName"] as? String)
            ?? "App"
        self.appVersion = appVersion
            ?? (bundle.infoDictionary?["CFBundleShortVersionString"] as? String)
            ?? "1.0"
        self.buildNumber = buildNumber
            ?? (bundle.infoDictionary?["CFBundleVersion"] as? String)
            ?? "1"
        self.supportURL = supportURL
        self.termsURL = termsURL
        self.privacyURL = privacyURL
        self.companyName = companyName
        self.recordsTitle = recordsTitle
        self.recordsCount = recordsCount
        self.additionalLinks = additionalLinks
    }
}
