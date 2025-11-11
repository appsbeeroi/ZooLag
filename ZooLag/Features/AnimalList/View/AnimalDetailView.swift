import SwiftUI

struct AnimalDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AnimalListViewModel
    
    let animal: Animal
    
    @State private var isShowRemoveAlert = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .expand()
            
            VStack(spacing: 20) {
                navBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        image
                        info
                        description
                    }
                    .padding(.horizontal, 35)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if viewModel.isLoading {
                LoaderView()
            }
        }
        .navigationBarBackButtonHidden()
        .alert("Are you sure?", isPresented: $isShowRemoveAlert) {
            Button("Yes", role: .destructive) {
                viewModel.remove(animal)
            }
        }
    }
    
    private var navBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Back")
                        .font(.system(size: 20, weight: .bold))
                    
                }
            }
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.navigationPath.append(.add(animal))
                } label: {
                    StrokedView(text: "Edit", color: .blue)
                }
                
                Button {
                    isShowRemoveAlert.toggle()
                } label: {
                    StrokedView(text: "Remove", color: .red)
                }
            }
        }
        .padding(.horizontal, 35)
        .foregroundStyle(.zlYellow)
    }
    
    private var image: some View {
        Image(uiImage: animal.image ?? .animalList)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 260)
            .clipped()
            .cornerRadius(100)
    }
    
    private var info: some View {
        VStack(spacing: 12) {
            Text(animal.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                if let category = animal.category {
                    VStack(spacing: 0) {
                        Image(category.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 65)
                        
                        Text(category.rawValue)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 100)
                    .padding(.vertical, 22)
                    .background(.white.opacity(0.15))
                    .cornerRadius(90)
                    .overlay {
                        RoundedRectangle(cornerRadius: 90)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
                }
                
                if let status = animal.status {
                    VStack(spacing: 0) {
                        Image(status.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 65)
                        
                        Text(status.rawValue)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 100)
                    .padding(.vertical, 22)
                    .background(.white.opacity(0.15))
                    .cornerRadius(90)
                    .overlay {
                        RoundedRectangle(cornerRadius: 90)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var description: some View {
        VStack {
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            Text(animal.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    AnimalDetailView(animal: Animal(isTrue: false))
        .environmentObject(AnimalListViewModel())
}


