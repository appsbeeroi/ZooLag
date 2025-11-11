import UIKit

enum AnimalStatus: String, Identifiable, CaseIterable, Codable {
    case seen = "Seen"
    case wantToSee = "Want to see"
    
    var id: Self {
        self
    }
    
    var icon: ImageResource {
        switch self {
            case .seen:
                    .seen
            case .wantToSee:
                    .wantToSee
        }
    }
}
