import SwiftUI

struct AnimalListView: View {
    
    @StateObject private var viewModel = AnimalListViewModel()
    
    @Binding var showTab: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.background)
                    .expand()
                
                VStack(spacing: 20) {
                    Text("Animal List")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    if viewModel.baseAnimals.isEmpty {
                      stumb
                    } else {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 24) {
                                    categoryPicker
                                    animals
                                }
                                .padding(.horizontal, 1)
                            }
                            
                            addButton
                        }
                        .padding(.horizontal, 35)
                        .padding(.bottom, 100)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(for: AnimalScreen.self) { screen in
                switch screen {
                    case .add(let animal):
                        AnimalAddView(animal: animal)
                    case .detail(let animal):
                        AnimalDetailView(animal: animal)
                }
            }
            .onAppear {
                showTab = true 
                viewModel.downloadAnimals()
            }
        }
        .environmentObject(viewModel)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            StumbView(
                image: .jail,
                title: "While this is empty...",
                subtitle: "Add your first animal to start tracking it!"
            )
            
            addButton
        }
        .frame(maxHeight: .infinity)
        .padding(.bottom, 100)
        .padding(.horizontal, 35)
    }
    
    private var addButton: some View {
        Button {
            showTab = false
            viewModel.navigationPath.append(.add(Animal(isTrue: true)))
        } label: {
            Text("Add animal")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.zlBrown)
                .background(.zlYellow)
                .cornerRadius(45)
        }
    }
    
    private var categoryPicker: some View {
        VStack(spacing: 4) {
            Text("Category")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            HStack {
                ForEach(AnimalCategory.allCases) { category in
                    Button {
                        viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                    } label: {
                        HStack(spacing: 0) {
                            Image(category.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 40)
                            
                            Text(category.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedCategory == category ? .zlPink : .white.opacity(0.15))
                        .cornerRadius(90)
                        .overlay {
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                    }
                }
            }
        }
    }
    
    private var animals: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.animals) { animal in
                AnimalCellView(animal: animal) {
                    showTab = false
                    viewModel.navigationPath.append(.detail(animal))
                }
            }
        }
    }
}

#Preview {
    AnimalListView(showTab: .constant(false))
}

