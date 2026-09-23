import Foundation

/// Filename, tag, and OCR text search. All matching stays on the device.
public enum SearchMatch {
    public static func matches(_ document: Document, query: String) -> Bool {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return true }
        if document.originalFileName?.lowercased().contains(q) == true { return true }
        if document.ocrText.lowercased().contains(q) { return true }
        if document.tags.contains(where: { $0.name.lowercased().contains(q) }) { return true }
        if document.metadata.values.contains(where: { $0.lowercased().contains(q) }) { return true }
        return false
    }
}
