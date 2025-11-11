import UIKit

enum TabBarItem: Identifiable, CaseIterable {
    case list
    case log
    case notes
    case settings
    
    var id: Self {
        self
    }
    
    var icon: ImageResource {
        switch self {
            case .list:
                    .animalList
            case .log:
                    .log
            case .notes:
                    .notes
            case .settings:
                    .settings
        }
    }
}
