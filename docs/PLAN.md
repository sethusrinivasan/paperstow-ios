# Paperstow iOS — build order

Native Swift app. Same product purpose as Android Paperstow 1.1. Separate from `document-manager`.

## Done on Linux (this environment)

Phase 0 plus everything that does not need Xcode:

- GitHub repo, license, gitignore
- `PaperstowCore` Swift package: models, limits, format detect, AES-GCM, backup manifest, search, auto-tags, trail math, GPX
- Unit tests for those rules
- CI: `swift test` on Ubuntu
- Docs: architecture, backup format, App Store, privacy
- Store brand copies under `docs/brand/`

`swift test` is the check this environment (and GitHub Actions) can run. CI uses the official `swift:6.0` container on Ubuntu, not `setup-swift@v2`.

## Next step (needs a Mac)

**Create the Xcode iOS app target and wire it to `PaperstowCore`.**

On a Mac with Xcode 16+:

1. `File → New → Project → App` (SwiftUI, iOS 17, bundle ID `com.app.paperstow`).
2. Add the local Swift package (`PaperstowCore`) to the app target.
3. Build the first screens only: EULA → Face ID / passcode unlock → empty Home.
4. Then import a file, encrypt with `FileEncryptor` + Keychain, list it, preview, search with `SearchMatch`.
5. Simulator screenshots for App Store. Do not start My Trail in 1.0.

That work cannot be done on this Linux machine. There is no iOS SDK here.

## After the Xcode shell

- **Phase 2** — ZIP archive to Files (optional password), restore using `BackupManifest.looksComplete`
- **Phase 3** — notes, checklists, folder import, tips, About
- **Phase 4** — My Trail only if we want it; Core Location, When In Use, user Start/Stop
- **Phase 5** — TestFlight and App Store (see `docs/APP_STORE.md`)

## What we will not do

- Put this project inside the Android repo
- Port Room, Hilt, ML Kit, or `SafetyTrailService`
- Add a Paperstow account or cloud sync
- Claim features that are not in the binary
