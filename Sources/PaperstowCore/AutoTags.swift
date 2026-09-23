/// Type and date tags. Same names as Android `AutoTagGeneratorImpl`.
public enum AutoTags {
    public static func generate(type: DocumentType, metadata: [MetadataField: String]) -> [String] {
        var tags: [String] = []
        if let typeTag = typeTag(type) {
            tags.append(typeTag)
        }
        if let destination = metadata[.destination]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !destination.isEmpty {
            tags.append(destination.lowercased())
        }
        if let year = year(in: metadata[.expiryDate]) {
            tags.append("expires-\(year)")
        }
        if let year = year(in: metadata[.issueDate]) {
            tags.append("issued-\(year)")
        }
        return tags
    }

    private static func typeTag(_ type: DocumentType) -> String? {
        switch type {
        case .passport: return "passport"
        case .visa: return "visa"
        case .ticket: return "ticket"
        case .hotelBooking: return "accommodation"
        case .healthInsurance: return "health"
        case .unknown: return nil
        }
    }

    private static func year(in value: String?) -> String? {
        guard let value, !value.isEmpty else { return nil }
        guard let match = value.range(of: #"\b(\d{4})\b"#, options: .regularExpression) else {
            return nil
        }
        return String(value[match])
    }
}
