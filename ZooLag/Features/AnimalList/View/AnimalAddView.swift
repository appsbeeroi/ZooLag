import SwiftUI

struct AnimalAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AnimalListViewModel
    
    @State var animal: Animal
    
    @State private var isShowImagePicker = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.background)
                .expand()
            
            VStack(spacing: 20) {
                navBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        image
                        name
                        category
                        description
                        status
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
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $animal.image)
        }
    }
    
    private var navBar: some View {
        ZStack {
            Text("Add animal")
                .font(.system(size: 25, weight: .heavy))
                .foregroundStyle(.white)
            
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
                
                Button {
                    viewModel.save(animal)
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .bold))
                        .opacity(animal.isAvailable ? 1 : 0.5)
                }
                .disabled(!animal.isAvailable)
            }
            .foregroundStyle(.zlYellow)
        }
        .padding(.horizontal, 35)
    }
    
    private var image: some View {
        Button {
            isShowImagePicker = true
        } label: {
            ZStack {
                if let image = animal.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipped()
                        .cornerRadius(100)
                } else {
                    Circle()
                        .frame(width: 180, height: 180)
                        .foregroundStyle(.white.opacity(0.15))
                }
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
    
    private var name: some View {
        VStack {
            Text("Animal name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $animal.name, isFocused: $isFocused)
        }
    }
    
    private var category: some View {
        VStack {
            Text("Category")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            HStack(spacing: 8) {
                ForEach(AnimalCategory.allCases) { category in
                    Button {
                        animal.category = category
                    } label: {
                        VStack(spacing: 0) {
                            Image(category.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 65)
                                
                            Text(category.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(animal.category == category ? .zlPink : .white.opacity(0.15))
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
    
    private var description: some View {
        VStack {
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $animal.description, isFocused: $isFocused)
        }
    }
    
    private var status: some View {
        VStack {
            Text("Category")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            HStack(spacing: 8) {
                ForEach(AnimalStatus.allCases) { status in
                    Button {
                        animal.status = status
                    } label: {
                        VStack(spacing: 0) {
                            Image(status.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 65)
                                
                            Text(status.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 110)
                        .padding(.vertical, 22)
                        .background(animal.status == status ? .zlPink : .white.opacity(0.15))
                        .cornerRadius(90)
                        .overlay {
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AnimalAddView(animal: Animal(isTrue: false))
        .environmentObject(AnimalListViewModel())
}


