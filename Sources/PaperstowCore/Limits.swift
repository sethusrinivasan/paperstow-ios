/// Product caps. Same numbers as Paperstow 1.1 on Android.
public enum Limits {
    public static let maxDocumentsPerMember = 100
    public static let maxTagsPerDocument = 20
    public static let maxFolderImportFiles = 500

    public static func canAddDocument(currentCount: Int) -> Bool {
        currentCount < maxDocumentsPerMember
    }

    public static func canAddTag(currentCount: Int) -> Bool {
        currentCount < maxTagsPerDocument
    }

    public static func folderImportCap<T>(_ files: [T]) -> [T] {
        Array(files.prefix(maxFolderImportFiles))
    }
}
