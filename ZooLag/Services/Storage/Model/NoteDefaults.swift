import Foundation

struct NoteDefaults: Codable {
    let id: UUID
    let title: String
    let notes: String
    
    init(from model: Note) {
        self.id = model.id
        self.title = model.title
        self.notes = model.notes
    }
}
