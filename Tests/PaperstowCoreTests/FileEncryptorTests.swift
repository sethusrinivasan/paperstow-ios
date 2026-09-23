import Crypto
import PaperstowCore
import XCTest

final class FileEncryptorTests: XCTestCase {
    func testRoundTrip() throws {
        let key = FileEncryptor.randomKey()
        let plain = Data("family passport scan".utf8)
        let blob = try FileEncryptor.encrypt(plain, key: key)
        XCTAssertGreaterThan(blob.count, FileEncryptor.nonceLength + FileEncryptor.tagLength)
        XCTAssertEqual(try FileEncryptor.decrypt(blob, key: key), plain)
    }

    func testWrongKeyFails() {
        let plain = Data("secret".utf8)
        let blob = try! FileEncryptor.encrypt(plain, key: FileEncryptor.randomKey())
        XCTAssertThrowsError(try FileEncryptor.decrypt(blob, key: FileEncryptor.randomKey()))
    }

    func testSha256HexIsStable() {
        XCTAssertEqual(
            FileEncryptor.sha256Hex(Data("abc".utf8)),
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        )
    }
}
