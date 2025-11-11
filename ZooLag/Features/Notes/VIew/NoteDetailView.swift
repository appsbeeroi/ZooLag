import SwiftUI

struct NoteDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: PersonalNotesViewModel
    
    let note: Note
    
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
                viewModel.remove(note)
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
                    viewModel.navigationPath.append(.add(note))
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
        Image(uiImage: note.image ?? .animalList)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 260)
            .clipped()
            .cornerRadius(100)
    }
    
    private var info: some View {
        VStack(spacing: 18) {
            Text(note.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            Text(note.notes)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NoteDetailView(note: Note(isTrue: false))
        .environmentObject(PersonalNotesViewModel())
}
