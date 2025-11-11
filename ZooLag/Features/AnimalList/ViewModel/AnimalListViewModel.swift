import Foundation
import Combine

final class AnimalListViewModel: ObservableObject {
    
    private let storage = DefaultsStorage.instance
    private let imageVault = ImageVault.instance
    
    @Published var navigationPath: [AnimalScreen] = []
    @Published var selectedCategory: AnimalCategory?
    
    @Published private(set) var animals: [Animal] = []
    @Published private(set) var isLoading = false 
    
    private(set) var baseAnimals: [Animal] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeCategory()
    }
    
    func downloadAnimals() {
        Task { [weak self] in
            guard let self else { return }
            
            let animals = await self.storage.readObject(as: [AnimalDefault].self, key: .animal) ?? []
            
            let result = await withTaskGroup(of: Animal?.self) { group in
                for defaults in animals {
                    group.addTask {
                        guard let image = await self.imageVault.retrieve(id: defaults.id) else { return nil }
                        let animal = Animal(from: defaults, image: image)
                        
                        return animal
                    }
                }
                
                var animals: [Animal?] = []
                
                for await animal in group {
                    animals.append(animal)
                }
                
                return animals.compactMap { $0 }
            }
            
            await MainActor.run {
                self.baseAnimals = result
                self.animals = result
            }
        }
    }
    
    func save(_ animal: Animal) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var animals = await self.storage.readObject(as: [AnimalDefault].self, key: .animal) ?? []
            
            guard let image = animal.image else { return }
            await self.imageVault.store(image, id: animal.id)
            let defaults = AnimalDefault(from: animal)
            
            if let index = animals.firstIndex(where: { $0.id == animal.id }) {
                animals[index] = defaults
            } else {
                animals.append(defaults)
            }
            
            await self.storage.saveObject(animals, key: .animal)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
    
    func remove(_ animal: Animal) {
        isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            var animals = await self.storage.readObject(as: [AnimalDefault].self, key: .animal) ?? []
            
            guard let image = animal.image else { return }
            await self.imageVault.store(image, id: animal.id)
            
            if let index = animals.firstIndex(where: { $0.id == animal.id }) {
                animals.remove(at: index)
            }
            
            await self.imageVault.remove(id: animal.id)
            await self.storage.saveObject(animals, key: .animal)
        
            await MainActor.run {
                self.isLoading = false
                self.navigationPath.removeAll()
            }
        }
    }
    
    private func observeCategory() {
        $selectedCategory
            .sink { [weak self] category in
                guard let self else { return }
                
                if let category {
                    self.animals = self.baseAnimals.filter { $0.category == category }
                } else {
                    self.animals = self.baseAnimals
                }
            }
            .store(in: &cancellables)
    }
}
