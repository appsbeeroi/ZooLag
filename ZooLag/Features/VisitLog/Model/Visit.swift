import UIKit

struct Visit: Identifiable, Hashable {
    let id: UUID
    var image: UIImage?
    var zoo: String
    var date: Date
    var notes: String
    
    var isAvailable: Bool {
        image != nil && zoo != "" && notes != ""
    }
    
    init(isTrue: Bool) {
        self.id = UUID()
        self.image = isTrue ? nil : .mammal
        self.zoo = isTrue ? "" : "National Zoo"
        self.date = .init()
        self.notes = isTrue ? "" : "Very happy"
    }
    
    init(from defaults: VisitDefaults, image: UIImage) {
        self.id = defaults.id
        self.image = image
        self.zoo = defaults.zoo
        self.date = defaults.date
        self.notes = defaults.notes
    }
}


