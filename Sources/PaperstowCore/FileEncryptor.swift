import Crypto
import Foundation

/// AES-256-GCM. On-disk layout matches Android: 12-byte nonce + ciphertext + 16-byte tag.
public enum FileEncryptor {
    public static let nonceLength = 12
    public static let tagLength = 16

    public static func randomKey() -> SymmetricKey {
        SymmetricKey(size: .bits256)
    }

    public static func encrypt(_ plaintext: Data, key: SymmetricKey) throws -> Data {
        let sealed = try AES.GCM.seal(plaintext, using: key)
        guard let combined = sealed.combined else {
            throw EncryptorError.missingCombinedBox
        }
        return combined
    }

    public static func decrypt(_ blob: Data, key: SymmetricKey) throws -> Data {
        let box = try AES.GCM.SealedBox(combined: blob)
        return try AES.GCM.open(box, using: key)
    }

    public static func sha256Hex(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    public enum EncryptorError: Error, Equatable {
        case missingCombinedBox
    }
}
