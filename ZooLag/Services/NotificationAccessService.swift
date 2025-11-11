import UIKit
import UserNotifications

final class NotificationAccessService {
    
    static let instance = NotificationAccessService()
    
    private init() {}
    
    enum AccessState {
        case allowed
        case refused
        case undefined
    }
    
    var currentState: AccessState {
        get async {
            let notificationCenter = UNUserNotificationCenter.current()
            let settings = await notificationCenter.notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return .allowed
            case .denied:
                return .refused
            case .notDetermined:
                return .undefined
            @unknown default:
                return .refused
            }
        }
    }
    
    @discardableResult
    func requestPermission() async -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        do {
            let isGranted = try await notificationCenter.requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            return isGranted
        } catch {
            print("⚠️ Failed to request notification permission: \(error.localizedDescription)")
            return false
        }
    }
}
