import XCTest
@testable import KappzKit

final class KappzKitTests: XCTestCase {
    func testConfigurationDefaults() {
        let config = KappzConfiguration(appName: "BaroPulse", appVersion: "1.2.0", buildNumber: "42", recordsCount: 15)
        XCTAssertEqual(config.appName, "BaroPulse")
        XCTAssertEqual(config.appVersion, "1.2.0")
        XCTAssertEqual(config.buildNumber, "42")
        XCTAssertEqual(config.formattedVersion, "1.2.0 (42)")
        XCTAssertEqual(config.recordsCount, 15)
        XCTAssertEqual(config.supportURL.absoluteString, "https://kappz.net/contact.html")
        XCTAssertEqual(config.termsURL.absoluteString, "https://kappz.net/terms.html")
        XCTAssertEqual(config.privacyURL.absoluteString, "https://kappz.net/privacy.html")
        XCTAssertTrue(config.copyrightText.contains("Kappz LLC"))
    }

    func testCustomLinks() {
        let customLink = KappzLinkItem(title: "Website", systemImage: "globe", url: URL(string: "https://kappz.net")!)
        let config = KappzConfiguration(additionalLinks: [customLink])
        XCTAssertEqual(config.additionalLinks.count, 1)
        XCTAssertEqual(config.additionalLinks.first?.title, "Website")
    }
}
