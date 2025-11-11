import UIKit

struct Note: Identifiable, Hashable {
    let id: UUID
    var image: UIImage?
    var title: String
    var notes: String
    
    var isAvailable: Bool {
        image != nil && title != "" && notes != ""
    }
    
    init(isTrue: Bool) {
        self.id = UUID()
        self.image = isTrue ? nil : .mammal
        self.title = isTrue ? "" : "Title"
        self.notes = isTrue ? "" : "Notes"
    }
    
    init(from defaults: NoteDefaults, image: UIImage) {
        self.id = defaults.id
        self.image = image
        self.title = defaults.title
        self.notes = defaults.notes
    }
}
