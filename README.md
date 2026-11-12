# KappzKit

Reusable Swift Package providing standardized **About**, **Settings**, and **Legal** sections for all Kappz LLC iOS and macOS applications.

## Features
- Standardized About Section (`KappzAboutSection`) compatible with SwiftUI `List` and `Form`.
- Full-screen / Modal Sheet view (`KappzAboutView`).
- Dynamic bundle version & build detection.
- App review prompt via StoreKit (`requestReview`).
- Built-in links for Kappz LLC Support, Terms of Service, and Privacy Policy.
- Fully accessible with Dynamic Type and Dark Mode.

## Usage

```swift
import KappzKit

// Directly embed inside a List / Form:
KappzAboutSection(config: KappzConfiguration(recordsCount: 42))

// Or present as a full sheet:
.sheet(isPresented: $showAbout) {
    KappzAboutView(config: KappzConfiguration(recordsTitle: "Total Readings", recordsCount: readings.count))
}
```
