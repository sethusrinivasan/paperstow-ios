# App Store checklist — Paperstow iOS 1.0 (vault)

Do this **after** the Xcode app exists and runs on a device or simulator.

## Identity

- Name: `Paperstow`
- Bundle ID: `com.app.paperstow` (change only if App IDs collide)
- Category: Utilities or Productivity

## Privacy Nutrition Labels

For 1.0 without My Trail:

- Data collected by the developer: none
- Location: no
- Tracking: no
- Camera: used to scan a page; photos stay on device

If My Trail ships later, add location (on device only, not shared).

## Usage strings (Info.plist, when the UI exists)

- `NSFaceIDUsageDescription` — Unlock Paperstow with Face ID.
- `NSCameraUsageDescription` — Scan a travel paper on this iPhone.
- Do not add location keys until Trail exists.

## Encryption questionnaire

Local AES-GCM for the user’s own files. Use the current export-compliance answers for encryption that is only used to protect data on the device.

## Graphics

Reuse the Play art in `docs/brand/` (512 icon, 1024×500 feature graphic). Capture iPhone screenshots from the simulator — do not upload Android shots.

## What 1.0 should claim

The same jobs as Android: import, on-device OCR, encrypt, tags, search, share, optional-password ZIP. Do not claim My Trail, iCloud, or a Paperstow account.
