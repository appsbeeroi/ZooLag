import UIKit

extension UIImage {
    func compressedTenTimes() -> UIImage? {
        let scaleFactor: CGFloat = 1 / 3.16
        let newSize = CGSize(width: size.width * scaleFactor,
                             height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let resized = resizedImage else { return nil }
        
        guard let jpegData = resized.jpegData(compressionQuality: 0.1) else {
            return nil
        }
        
        return UIImage(data: jpegData)
    }
}
