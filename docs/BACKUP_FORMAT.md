# Portable archive (`schemaVersion` 2)

Android 1.1 writes a ZIP that decrypts papers into the archive so another phone can restore them. iOS should write and read the same inventory.

## Layout

```
manifest.json
docs/…                 decrypted files
trail/my_trail.gpx     optional
```

Android also puts a Room snapshot at `database/traveldocs.db`. iOS must **not** open that file as its live store. Use `manifest.json` + `docs/` (and later a JSON/SQLite snapshot iOS owns). Cross-restore of Android Room DB is a later decision.

## `manifest.json`

```json
{
  "schemaVersion": 2,
  "timestamp": "ISO-8601",
  "appVersion": "1.0.0",
  "fileCount": 1,
  "totalSizeBytes": 0,
  "encrypted": false,
  "transportable": true,
  "files": [
    {
      "path": "docs/passport.pdf",
      "size": 123,
      "sha256": "hex",
      "originalFileId": "optional"
    }
  ]
}
```

`encrypted` means the **ZIP** has an optional AES password (4+ characters on Android). A blank password is an unprotected ZIP of readable files.

## Restore

1. Read `manifest.json` first.
2. Refuse the archive if it is incomplete (`looksComplete` in `BackupManifest`).
3. Verify SHA-256 of extracted files when present.
4. Only then replace live data.
