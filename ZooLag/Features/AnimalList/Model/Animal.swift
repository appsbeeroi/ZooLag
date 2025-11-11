import UIKit

struct Animal: Identifiable, Hashable {
    let id: UUID
    var image: UIImage?
    var name: String
    var category: AnimalCategory?
    var description: String
    var status: AnimalStatus?
    
    var isAvailable: Bool {
        image != nil && name != "" && category != nil && description != "" && status != nil
    }
    
    init(isTrue: Bool) {
        self.id = UUID()
        self.image = isTrue ? nil : .mammal
        self.name = isTrue ? "" : "Mammal"
        self.category = isTrue ? nil : .mammal
        self.description = isTrue ? "" : "Mammal Description"
        self.status = isTrue ? nil : .seen
    }
    
    init(from defaults: AnimalDefault, image: UIImage) {
        self.id = defaults.id
        self.image = image
        self.name = defaults.name
        self.category = defaults.category
        self.description = defaults.description
        self.status = defaults.status
    }
}
