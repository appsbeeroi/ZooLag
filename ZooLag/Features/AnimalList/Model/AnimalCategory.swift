import UIKit

enum AnimalCategory: String, Identifiable, CaseIterable, Codable {
    case mammal = "Mammal"
    case bird = "Bird"
    case reptile = "Reptile"
    
    var id: Self {
        self
    }
    
    var icon: ImageResource {
        switch self {
            case .mammal:
                    .mammal
            case .bird:
                    .bird
            case .reptile:
                    .reptile
        }
    }
}
