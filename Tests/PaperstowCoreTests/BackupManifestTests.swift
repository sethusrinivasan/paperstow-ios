import Foundation
import PaperstowCore
import XCTest

final class BackupManifestTests: XCTestCase {
    func testRoundTripJson() throws {
        let manifest = BackupManifest(
            timestamp: "2026-09-22T00:00:00Z",
            appVersion: "1.1.0",
            fileCount: 1,
            totalSizeBytes: 12,
            encrypted: false,
            files: [
                .init(path: "docs/a.pdf", size: 12, sha256: "abc", originalFileId: "1"),
            ]
        )
        let data = try manifest.encodePretty()
        let decoded = try BackupManifest.decode(data)
        XCTAssertEqual(decoded, manifest)
        XCTAssertTrue(decoded.looksComplete)
        XCTAssertEqual(decoded.schemaVersion, 2)
        XCTAssertTrue(decoded.transportable)
    }

    func testIncompleteWhenCountDoesNotMatchEmptyFiles() {
        let manifest = BackupManifest(
            timestamp: "t",
            appVersion: "1.0.0",
            fileCount: 3,
            totalSizeBytes: 1,
            encrypted: true,
            files: []
        )
        XCTAssertFalse(manifest.looksComplete)
    }
}
