import Foundation
import Combine

final class PersonalNotesViewModel: ObservableObject {
    
    private let storage = DefaultsStorage.instance
    private let imageVault = ImageVault.instance
    
    @Published var navigationPath: [NotesScreen] = []
    
    @Published private(set) var notes: [Note] = []
    @Published private(set) var isLoading = false

    func downloadNotes() {
        Task { [weak self] in
            guard let self else { return }
            
            let notesDefaults = await self.storage.readObject(as: [NoteDefaults].self, key: .notes) ?? []
            
            let result = await withTaskGroup(of: Note?.self) { group in
                for defaults in notesDefaults {
                    group.addTask {
                        guard let image = await self.imageVault.retrieve(id: defaults.id) else { return nil }
                        let note = Note(from: defaults, image: image)
                        
                        return note
                    }
                }
                
                var notes: [Note?] = []
                
                for await note in group {
                    notes.append(note)
                }
                
                return notes.compactMap { $0 }
            }
            
            await MainActor.run {
                self.notes = result
            }
        }
    }
    
    func save(_ note: Note) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var notesDefaults = await self.storage.readObject(as: [NoteDefaults].self, key: .notes) ?? []
            
            guard let image = note.image else { return }
            await self.imageVault.store(image, id: note.id)
            let defaults = NoteDefaults(from: note)
            
            if let index = notesDefaults.firstIndex(where: { $0.id == note.id }) {
                notesDefaults[index] = defaults
            } else {
                notesDefaults.append(defaults)
            }
            
            await self.storage.saveObject(notesDefaults, key: .notes)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
    
    func remove(_ note: Note) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var notesDefaults = await self.storage.readObject(as: [NoteDefaults].self, key: .notes) ?? []
            
            guard let image = note.image else { return }
            await self.imageVault.store(image, id: note.id)
            
            if let index = notesDefaults.firstIndex(where: { $0.id == note.id }) {
                notesDefaults.remove(at: index)
            }
            
            await self.imageVault.remove(id: note.id)
            await self.storage.saveObject(notesDefaults, key: .notes)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
}
