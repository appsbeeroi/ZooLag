import SwiftUI

struct NoteAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: PersonalNotesViewModel
    
    @State var note: Note
    
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
                        title
                        notes
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
            ImagePicker(selectedImage: $note.image)
        }
    }
    
    private var navBar: some View {
        ZStack {
            Text("Add note")
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
                    viewModel.save(note)
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .bold))
                        .opacity(note.isAvailable ? 1 : 0.5)
                }
                .disabled(!note.isAvailable)
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
                if let image = note.image {
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
    
    private var title: some View {
        VStack {
            Text("Title")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $note.title, isFocused: $isFocused)
        }
    }
    
    private var notes: some View {
        VStack {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $note.notes, isFocused: $isFocused)
        }
    }
}

#Preview {
   NoteAddView(note: Note(isTrue: false))
        .environmentObject(PersonalNotesViewModel())
}
