import Foundation

/// Magic-byte and name/MIME detection. Same rules as Android `DocumentFormatValidator`.
public enum DocumentFormatDetector {
    public static func detect(bytes: [UInt8], mimeType: String?, fileName: String?) -> DocumentFormat {
        if !bytes.isEmpty, let magic = detectFromMagicBytes(bytes) {
            return magic
        }
        let mime = mimeType?.lowercased() ?? ""
        let name = fileName?.lowercased() ?? ""
        if mime.contains("heic") || mime.contains("heif") || name.hasSuffix(".heic") || name.hasSuffix(".heif") {
            return .heic
        }
        if mime.contains("markdown") || name.hasSuffix(".md") || name.hasSuffix(".markdown") {
            return .markdown
        }
        if mime.contains("gpx") || name.hasSuffix(".gpx") || GpxTrail.looksLikeGpx(bytes) {
            return .gpx
        }
        if mime == "text/plain" || mime.hasPrefix("text/") || name.hasSuffix(".txt") {
            return .text
        }
        return .unknown
    }

    public static func detect(data: Data, mimeType: String?, fileName: String?) -> DocumentFormat {
        detect(bytes: Array(data), mimeType: mimeType, fileName: fileName)
    }

    public static func isSupportedForImport(mime: String?, fileName: String?) -> Bool {
        let mime = mime?.lowercased() ?? ""
        let name = fileName?.lowercased() ?? ""
        if mime.contains("video") || mime.contains("audio") || mime.contains("dicom") {
            return false
        }
        return mime.contains("pdf")
            || mime.contains("jpeg") || mime.contains("jpg")
            || mime.contains("png") || mime.contains("webp")
            || mime.contains("heic") || mime.contains("heif")
            || mime.contains("bmp") || mime.contains("gif")
            || mime == "text/plain" || mime.hasPrefix("text/")
            || name.hasSuffix(".pdf") || name.hasSuffix(".jpg") || name.hasSuffix(".jpeg")
            || name.hasSuffix(".png") || name.hasSuffix(".webp") || name.hasSuffix(".heic")
            || name.hasSuffix(".heif") || name.hasSuffix(".bmp") || name.hasSuffix(".gif")
            || name.hasSuffix(".txt") || name.hasSuffix(".md") || name.hasSuffix(".markdown")
            || name.hasSuffix(".gpx")
    }

    public static func detectFromMagicBytes(_ bytes: [UInt8]) -> DocumentFormat? {
        guard !bytes.isEmpty else { return nil }
        if isPdf(bytes) { return .pdf }
        if isJpeg(bytes) { return .jpg }
        if isPng(bytes) { return .png }
        if isWebP(bytes) { return .webp }
        if isBmp(bytes) { return .bmp }
        if isGif(bytes) { return .gif }
        return nil
    }

    private static func isPdf(_ b: [UInt8]) -> Bool {
        b.count >= 4 && b[0] == 0x25 && b[1] == 0x50 && b[2] == 0x44 && b[3] == 0x46
    }

    private static func isJpeg(_ b: [UInt8]) -> Bool {
        b.count >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF
    }

    private static func isPng(_ b: [UInt8]) -> Bool {
        b.count >= 4 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47
    }

    private static func isWebP(_ b: [UInt8]) -> Bool {
        b.count >= 12
            && b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46
            && b[8] == 0x57 && b[9] == 0x45 && b[10] == 0x42 && b[11] == 0x50
    }

    private static func isBmp(_ b: [UInt8]) -> Bool {
        b.count >= 2 && b[0] == 0x42 && b[1] == 0x4D
    }

    private static func isGif(_ b: [UInt8]) -> Bool {
        b.count >= 6 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x38
    }
}
