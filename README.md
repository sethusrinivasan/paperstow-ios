# Paperstow for iOS

Keep a copy of your family travel papers on this iPhone. Encrypted. No account. No cloud.

This is a **native iOS** app, built from first principles in Swift. It is the same product as [Paperstow on Android](https://github.com/sethusrinivasan/document-manager), not a copy of that codebase.

**Intended bundle ID:** `com.app.paperstow`

## Why this repo exists

The Android app lives in `document-manager` (Play, Gradle, Room, KeyStore). iOS needs SwiftUI, Keychain, Vision, and App Store review. Mixing those in one tree would clutter Play CI and the Android listing.

## What this app is for

The same jobs as Paperstow 1.1 on Android:

- Import a PDF or photo, scan a page on the device, or pull in a folder (subfolder names become tags)
- Read the page with on-device OCR so Search can find words from the page
- Encrypt each file on this device (AES-256-GCM; keys in Keychain / Secure Enclave)
- Organize with tags, notes, and checklists
- Share a copy through the system share sheet
- Archive and restore a ZIP to Files (password optional)
- Unlock with Face ID, Touch ID, or the device passcode

My Trail (optional unique places for 24 hours) is **not** in the first App Store version. iOS has no Android-style location foreground service; that feature can be designed later if we want it.

## Status

`PaperstowCore` (Swift package) is in this repo and tested with `swift test` / GitHub Actions. It holds the product rules: limits, format detect, AES-GCM, backup manifest, search, GPX.

The **Xcode iOS app** is the next step and needs a Mac. See [docs/PLAN.md](docs/PLAN.md).

```bash
swift test
```

## Docs

| Doc | What it is |
|-----|------------|
| [docs/PLAN.md](docs/PLAN.md) | Build order and the next Mac step |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Layers |
| [docs/BACKUP_FORMAT.md](docs/BACKUP_FORMAT.md) | ZIP `schemaVersion` 2 |
| [docs/APP_STORE.md](docs/APP_STORE.md) | Listing and privacy labels |
| [docs/PRIVACY.md](docs/PRIVACY.md) | What stays on the phone |

## License

Apache License 2.0. See [LICENSE](LICENSE).
