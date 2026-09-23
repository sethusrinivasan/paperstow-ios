# Paperstow iOS — architecture

Native Swift. Same product as Android Paperstow 1.1. This repo does **not** contain Room, Hilt, ML Kit, or an Xcode app target yet.

```
SwiftUI app (Mac / Xcode — not in this tree yet)
        │
        ▼
PaperstowCore (this package — compiles on Linux and macOS)
  models, limits, format detect, AES-GCM, backup manifest,
  search match, auto-tags, UniqueLocations, GpxTrail
        │
        ▼
iOS-only adapters (next step on a Mac)
  Keychain, Vision / PDFKit / VisionKit, Files, LocalAuthentication
```

## What Core already encodes

| Rule | Value |
|------|--------|
| Docs per member | 100 |
| Tags per document | 20 |
| Folder import | 500 files |
| Encryption | AES-256-GCM, 12-byte nonce + ciphertext + tag |
| Backup manifest | `schemaVersion` 2, transportable ZIP inventory |
| Trail math | 150 m, 24 h (for a later iOS trail — not in 1.0 UI) |

## What stays on the device

Papers stay in the app container unless the user shares a file or exports a ZIP. No Paperstow account. No Paperstow servers. OCR on iOS will use Vision, not ML Kit.

## What is not here

- Xcode project / `.ipa`
- Keychain key wrapping
- UI, camera, Files picker
- My Trail start/stop (iOS location contract is different; deferred)
