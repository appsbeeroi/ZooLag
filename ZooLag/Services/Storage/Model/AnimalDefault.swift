import Foundation

struct AnimalDefault: Codable {
    let id: UUID
    let name: String
    let category: AnimalCategory
    let description: String
    let status: AnimalStatus
    
    init(from model: Animal) {
        self.id = model.id
        self.name = model.name
        self.category = model.category ?? .bird
        self.description = model.description
        self.status = model.status ?? .seen
    }
}
