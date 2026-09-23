# Paperstow iOS — build order

Native Swift app. Same product purpose as Android Paperstow 1.1. Separate from `document-manager`.

## Phase 0 — this repo

GitHub repository, README, license, gitignore. No Xcode target yet (needs a Mac).

## Phase 1 — vault

EULA → unlock → home → import file/scan → encrypt → tag → preview → search → share → reset. Sample trip for screenshots.

Stack: SwiftUI, LocalAuthentication, CryptoKit + Keychain, Vision + PDFKit + VisionKit, SQLite (GRDB or SwiftData). iOS 17 unless we need older devices.

## Phase 2 — archive

ZIP to Files, password optional, restore verifies the archive before swapping live data. Later we can define a shared `manifest.json` if Android ↔ iPhone restore matters.

## Phase 3 — polish

Notes, checklists, folder import, review/classify, tips, About (version + bundle ID).

## Phase 4 — My Trail (optional, after 1.0)

Rebuild with Core Location and a user Start/Stop. When In Use only. No silent Always-on tracking.

## Phase 5 — App Store

TestFlight, privacy nutrition labels, first `1.0.0`.

## What we will not do

- Put this project inside the Android repo
- Port Room, Hilt, ML Kit, or `SafetyTrailService`
- Add a Paperstow account or cloud sync
- Claim features that are not in the binary
