import Foundation

/// Unique places for My Trail. Same rules as Android: 150 m apart, 24-hour window.
public enum UniqueLocations {
    public static let minSeparationMeters = 150.0
    public static let windowMs: Int64 = 24 * 60 * 60 * 1000
    public static let maxAccuracyMeters: Float = 500

    public static func metersBetween(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthMeters = 6_371_000.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2)
            + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        return 2 * earthMeters * asin(sqrt(min(max(a, 0), 1)))
    }

    public static func isNewPlace(
        lastLat: Double,
        lastLon: Double,
        nextLat: Double,
        nextLon: Double,
        minMeters: Double = minSeparationMeters
    ) -> Bool {
        metersBetween(lat1: lastLat, lon1: lastLon, lat2: nextLat, lon2: nextLon) >= minMeters
    }

    public static func inWindow(
        _ places: [SafetyPlace],
        nowMs: Int64,
        windowMs: Int64 = windowMs
    ) -> [SafetyPlace] {
        places.filter { nowMs - $0.timestamp <= windowMs }
    }

    public static func mapsUrl(latitude: Double, longitude: Double) -> String {
        "https://maps.google.com/?q=\(latitude),\(longitude)"
    }

    public static func batteryLabel(_ percent: Int) -> String? {
        (0...100).contains(percent) ? "Battery \(percent)%" : nil
    }

    public static func shareAll(
        placesNewestFirst: [SafetyPlace],
        locale: Locale = Locale(identifier: "en_US"),
        timeZone: TimeZone = .current
    ) -> String {
        if placesNewestFirst.isEmpty {
            return "Paperstow — no unique places in My Trail on this phone."
        }
        let fmt = timeFormatter(locale: locale, timeZone: timeZone)
        let last = placesNewestFirst[0]
        var lines: [String] = [
            "Paperstow — My Trail (this phone only)",
            "",
            "Last known (\(fmt.string(from: date(last.timestamp))))\(batterySuffix(last)):",
            mapsUrl(latitude: last.latitude, longitude: last.longitude),
        ]
        let earlier = Array(placesNewestFirst.dropFirst())
        if !earlier.isEmpty {
            lines.append("")
            lines.append("Earlier:")
            for place in earlier {
                lines.append(
                    "• \(fmt.string(from: date(place.timestamp)))\(batterySuffix(place)) — \(mapsUrl(latitude: place.latitude, longitude: place.longitude))"
                )
            }
        }
        return lines.joined(separator: "\n")
    }

    public static func shareLastKnown(
        _ place: SafetyPlace,
        locale: Locale = Locale(identifier: "en_US"),
        timeZone: TimeZone = .current
    ) -> String {
        let fmt = timeFormatter(locale: locale, timeZone: timeZone)
        return [
            "Paperstow — last known place",
            "\(fmt.string(from: date(place.timestamp)))\(batterySuffix(place))",
            mapsUrl(latitude: place.latitude, longitude: place.longitude),
        ].joined(separator: "\n")
    }

    private static func batterySuffix(_ place: SafetyPlace) -> String {
        guard let label = batteryLabel(place.batteryPercent) else { return "" }
        return " · \(label)"
    }

    private static func date(_ ms: Int64) -> Date {
        Date(timeIntervalSince1970: TimeInterval(ms) / 1000)
    }

    private static func timeFormatter(locale: Locale, timeZone: TimeZone) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.locale = locale
        fmt.timeZone = timeZone
        fmt.dateFormat = "h:mm a"
        return fmt
    }
}
