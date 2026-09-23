import PaperstowCore
import XCTest

final class DocumentFormatDetectorTests: XCTestCase {
    func testPdfMagic() {
        XCTAssertEqual(DocumentFormatDetector.detectFromMagicBytes([0x25, 0x50, 0x44, 0x46, 0x2D]), .pdf)
    }

    func testJpegMagic() {
        XCTAssertEqual(DocumentFormatDetector.detectFromMagicBytes([0xFF, 0xD8, 0xFF, 0xE0]), .jpg)
    }

    func testPngMagic() {
        XCTAssertEqual(DocumentFormatDetector.detectFromMagicBytes([0x89, 0x50, 0x4E, 0x47]), .png)
    }

    func testMarkdownFromName() {
        XCTAssertEqual(
            DocumentFormatDetector.detect(bytes: Array("hi".utf8), mimeType: nil, fileName: "note.md"),
            .markdown
        )
    }

    func testGpxFromBytes() {
        let gpx = Array(GpxTrail.toGpx([]).utf8)
        XCTAssertEqual(DocumentFormatDetector.detect(bytes: gpx, mimeType: nil, fileName: nil), .gpx)
    }

    func testVideoMimeIsNotImportable() {
        XCTAssertFalse(DocumentFormatDetector.isSupportedForImport(mime: "video/mp4", fileName: "a.mp4"))
        XCTAssertTrue(DocumentFormatDetector.isSupportedForImport(mime: "application/pdf", fileName: "a.pdf"))
    }
}
