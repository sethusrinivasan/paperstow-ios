import Foundation

/// Versioned ZIP inventory. Android 1.1 writes `schemaVersion` 2 with these fields.
public struct BackupManifest: Equatable, Codable, Sendable {
    public var schemaVersion: Int
    public var timestamp: String
    public var appVersion: String
    public var fileCount: Int
    public var totalSizeBytes: Int64
    public var encrypted: Bool
    public var transportable: Bool
    public var files: [BackupFile]

    public init(
        schemaVersion: Int = 2,
        timestamp: String,
        appVersion: String,
        fileCount: Int,
        totalSizeBytes: Int64,
        encrypted: Bool,
        transportable: Bool = true,
        files: [BackupFile]
    ) {
        self.schemaVersion = schemaVersion
        self.timestamp = timestamp
        self.appVersion = appVersion
        self.fileCount = fileCount
        self.totalSizeBytes = totalSizeBytes
        self.encrypted = encrypted
        self.transportable = transportable
        self.files = files
    }

    public struct BackupFile: Equatable, Codable, Sendable {
        public var path: String
        public var size: Int64
        public var sha256: String
        public var originalFileId: String?

        public init(path: String, size: Int64, sha256: String, originalFileId: String? = nil) {
            self.path = path
            self.size = size
            self.sha256 = sha256
            self.originalFileId = originalFileId
        }
    }

    public static func decode(_ data: Data) throws -> BackupManifest {
        try JSONDecoder().decode(BackupManifest.self, from: data)
    }

    public func encodePretty() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }

    /// Restore must refuse an archive that claims files but lists none.
    public var looksComplete: Bool {
        schemaVersion >= 1 && fileCount >= 0 && (fileCount == 0 || !files.isEmpty)
    }
}
