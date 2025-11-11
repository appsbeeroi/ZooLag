enum SettingsSection: String, CaseIterable, Identifiable {
    case about = "About the App"
    case notification = "Notification"
    case clear = "Clear all data"
    
    var id: Self {
        self
    }
}
