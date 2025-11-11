import Foundation

struct VisitDefaults: Codable {
    let id: UUID
    let zoo: String
    let date: Date
    let notes: String
    
    init(from model: Visit) {
        self.id = model.id
        self.zoo = model.zoo
        self.date = model.date
        self.notes = model.notes
    }
}
