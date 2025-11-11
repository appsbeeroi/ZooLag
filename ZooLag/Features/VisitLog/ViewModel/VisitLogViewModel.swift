import Foundation
import Combine

final class VisitLogViewModel: ObservableObject {
    
    private let storage = DefaultsStorage.instance
    private let imageVault = ImageVault.instance
    
    @Published var navigationPath: [VisitLogScreen] = []
    
    @Published private(set) var visits: [Visit] = []
    @Published private(set) var isLoading = false
    
    func downloadVisits() {
        Task { [weak self] in
            guard let self else { return }
            
            let visitsDefaults = await self.storage.readObject(as: [VisitDefaults].self, key: .visits) ?? []
            
            let result = await withTaskGroup(of: Visit?.self) { group in
                for defaults in visitsDefaults {
                    group.addTask {
                        guard let image = await self.imageVault.retrieve(id: defaults.id) else { return nil }
                        let visit = Visit(from: defaults, image: image)
                        
                        return visit
                    }
                }
                
                var visits: [Visit?] = []
                
                for await visit in group {
                    visits.append(visit)
                }
                
                return visits.compactMap { $0 }
            }
            
            await MainActor.run {
                self.visits = result
            }
        }
    }
    
    func save(_ visit: Visit) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var visitsDefaults = await self.storage.readObject(as: [VisitDefaults].self, key: .visits) ?? []
            
            guard let image = visit.image else { return }
            await self.imageVault.store(image, id: visit.id)
            let defaults = VisitDefaults(from: visit)
            
            if let index = visitsDefaults.firstIndex(where: { $0.id == visit.id }) {
                visitsDefaults[index] = defaults
            } else {
                visitsDefaults.append(defaults)
            }
            
            await self.storage.saveObject(visitsDefaults, key: .visits)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
    
    func remove(_ visit: Visit) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var visitsDefaults = await self.storage.readObject(as: [VisitDefaults].self, key: .visits) ?? []
            
            guard let image = visit.image else { return }
            await self.imageVault.store(image, id: visit.id)
            let defaults = VisitDefaults(from: visit)
            
            if let index = visitsDefaults.firstIndex(where: { $0.id == visit.id }) {
                visitsDefaults.remove(at: index)
            }
            
            await self.imageVault.remove(id: visit.id)
            await self.storage.saveObject(visitsDefaults, key: .animal)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
}
