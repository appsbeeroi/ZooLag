import SwiftUI

struct PersonalNotesView: View {
    
    @StateObject private var viewModel = PersonalNotesViewModel()
    
    @Binding var showTab: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.background)
                    .expand()
                
                VStack(spacing: 20) {
                    Text("Personal Notes")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    if viewModel.notes.isEmpty {
                        stumb
                    } else {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 24) {
                                    LazyVGrid(
                                        columns: Array(repeating: GridItem(spacing: 8), count: 2),
                                        spacing: 8) {
                                            ForEach(viewModel.notes) { note in
                                                NoteCellView(note: note) {
                                                    showTab = false
                                                    viewModel.navigationPath.append(.detail(note))
                                                }
                                            }
                                        }
                                }
                                .padding(.top, 1)
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
            .navigationDestination(for: NotesScreen.self) { screen in
                switch screen {
                    case .add(let note):
                        NoteAddView(note: note)
                    case .detail(let note):
                        NoteDetailView(note: note)
                }
            }
            .onAppear {
                showTab = true
                viewModel.downloadNotes()
            }
        }
        .environmentObject(viewModel)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            StumbView(
                image: .visitLog,
                title: "No notes yet..",
                subtitle: "Add a note about your favorite animal or zoo experience!"
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
            viewModel.navigationPath.append(.add(Note(isTrue: true)))
        } label: {
            Text("Add note")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.zlBrown)
                .background(.zlYellow)
                .cornerRadius(45)
        }
    }
}

#Preview {
    PersonalNotesView(showTab: .constant(false))
}

