import UIKit

actor ImageVault {
        
    static let instance = ImageVault()
    
    private let cache = NSCache<NSString, UIImage>()
    private let manager = FileManager.default
    private let storageDirectory: URL
    
    private init() {
        let root = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        storageDirectory = root.appendingPathComponent("VaultImages", isDirectory: true)
        prepareDirectory()
    }
    
    private func prepareDirectory() {
        var isDir: ObjCBool = false
        if !manager.fileExists(atPath: storageDirectory.path, isDirectory: &isDir) || !isDir.boolValue {
            do {
                try manager.createDirectory(at: storageDirectory, withIntermediateDirectories: true)
                debugPrint("📂 Created image vault at:", storageDirectory.path)
            } catch {
                debugPrint("🚫 Directory creation failed:", error.localizedDescription)
            }
        }
    }
    
    private func path(for id: UUID) -> URL {
        storageDirectory.appendingPathComponent("\(id.uuidString).png")
    }
    
    @discardableResult
    func store(_ image: UIImage, id: UUID) -> String? {
        guard let data = image.pngData() else {
            debugPrint("⚠️ Could not convert image to PNG data")
            return nil
        }
        
        let fileURL = path(for: id)
        do {
            try data.write(to: fileURL, options: .atomic)
            cache.setObject(image, forKey: id.uuidString as NSString)
            debugPrint("💾 Saved image:", fileURL.lastPathComponent)
            return fileURL.lastPathComponent
        } catch {
            debugPrint("🚫 Failed to write image:", error.localizedDescription)
            return nil
        }
    }
    
    func retrieve(id: UUID) -> UIImage? {
        if let cached = cache.object(forKey: id.uuidString as NSString) {
            return cached
        }
        
        let fileURL = path(for: id)
        guard manager.fileExists(atPath: fileURL.path) else {
            debugPrint("🔍 No image for id:", id)
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            debugPrint("🚫 Could not decode image file:", fileURL.lastPathComponent)
            return nil
        }
        
        cache.setObject(image, forKey: id.uuidString as NSString)
        return image
    }
    
    func remove(id: UUID) {
        let fileURL = path(for: id)
        cache.removeObject(forKey: id.uuidString as NSString)
        
        guard manager.fileExists(atPath: fileURL.path) else {
            debugPrint("⚠️ Attempted to delete non-existing image:", fileURL.lastPathComponent)
            return
        }
        
        do {
            try manager.removeItem(at: fileURL)
            debugPrint("🗑️ Deleted image:", fileURL.lastPathComponent)
        } catch {
            debugPrint("🚫 Failed to delete:", error.localizedDescription)
        }
    }
    
    func exists(for id: UUID) -> Bool {
        let fileURL = path(for: id)
        return manager.fileExists(atPath: fileURL.path)
    }
}
