import Foundation

/// GPX 1.1 write/read for My Trail points. Same XML shape as Android so a ZIP can open in a map app.
public enum GpxTrail {
    public static func toGpx(_ placesOldestFirst: [SafetyPlace], name: String = "My Trail") -> String {
        var body = ""
        body += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        body += "<gpx version=\"1.1\" creator=\"Paperstow\" xmlns=\"http://www.topografix.com/GPX/1/1\">\n"
        body += "  <metadata>\n"
        body += "    <name>\(escape(name))</name>\n"
        body += "  </metadata>\n"
        body += "  <trk>\n"
        body += "    <name>\(escape(name))</name>\n"
        body += "    <trkseg>\n"
        for place in placesOldestFirst {
            body += "      <trkpt lat=\"\(place.latitude)\" lon=\"\(place.longitude)\">\n"
            body += "        <time>\(iso(place.timestamp))</time>\n"
            if (0...100).contains(place.batteryPercent) {
                body += "        <cmt>battery \(place.batteryPercent)%</cmt>\n"
            }
            body += "      </trkpt>\n"
        }
        body += "    </trkseg>\n"
        body += "  </trk>\n"
        body += "</gpx>\n"
        return body
    }

    public static func parse(_ xml: String) -> [SafetyPlace] {
        let point = try! NSRegularExpression(
            pattern: #"<(?:trkpt|wpt)\s+lat="([+-]?\d+(?:\.\d+)?)"\s+lon="([+-]?\d+(?:\.\d+)?)"\s*>(.*?)</(?:trkpt|wpt)>"#,
            options: [.dotMatchesLineSeparators, .caseInsensitive]
        )
        let timeTag = try! NSRegularExpression(pattern: #"<time>\s*([^<]+)\s*</time>"#, options: .caseInsensitive)
        let batteryTag = try! NSRegularExpression(pattern: #"battery\s+(\d{1,3})\s*%"#, options: .caseInsensitive)
        let ns = xml as NSString
        let full = NSRange(location: 0, length: ns.length)
        var points: [SafetyPlace] = []
        point.enumerateMatches(in: xml, options: [], range: full) { match, _, _ in
            guard let match else { return }
            guard match.numberOfRanges >= 4 else { return }
            let lat = Double(ns.substring(with: match.range(at: 1))) ?? 0
            let lon = Double(ns.substring(with: match.range(at: 2))) ?? 0
            let inner = ns.substring(with: match.range(at: 3))
            let innerNS = inner as NSString
            let innerRange = NSRange(location: 0, length: innerNS.length)
            var time: Int64 = 0
            if let tm = timeTag.firstMatch(in: inner, options: [], range: innerRange), tm.numberOfRanges >= 2 {
                time = parseISO(innerNS.substring(with: tm.range(at: 1)).trimmingCharacters(in: .whitespacesAndNewlines))
            }
            var battery = -1
            if let bm = batteryTag.firstMatch(in: inner, options: [], range: innerRange), bm.numberOfRanges >= 2 {
                battery = Int(innerNS.substring(with: bm.range(at: 1))) ?? -1
            }
            points.append(SafetyPlace(latitude: lat, longitude: lon, timestamp: time, batteryPercent: battery))
        }
        return points
    }

    public static func looksLikeGpx(_ bytes: [UInt8]) -> Bool {
        guard !bytes.isEmpty else { return false }
        let n = min(bytes.count, 800)
        let head = String(decoding: bytes.prefix(n), as: UTF8.self)
        return head.range(of: "<gpx", options: .caseInsensitive) != nil
    }

    public static func looksLikeGpx(_ data: Data) -> Bool {
        looksLikeGpx(Array(data))
    }

    private static func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func iso(_ ms: Int64) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return fmt.string(from: Date(timeIntervalSince1970: TimeInterval(ms) / 1000))
    }

    private static func parseISO(_ value: String) -> Int64 {
        let patterns = [
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ssX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        ]
        for pattern in patterns {
            let fmt = DateFormatter()
            fmt.locale = Locale(identifier: "en_US_POSIX")
            fmt.timeZone = TimeZone(secondsFromGMT: 0)
            fmt.dateFormat = pattern
            if let date = fmt.date(from: value) {
                return Int64(date.timeIntervalSince1970 * 1000)
            }
        }
        return 0
    }
}
