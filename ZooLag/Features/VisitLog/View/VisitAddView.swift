import SwiftUI

struct VisitAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: VisitLogViewModel
    
    @State var visit: Visit
    @State var datePicked: Bool
    
    @State private var isShowImagePicker = false
    @State private var isShowDatePicker = false
    
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
                        zoo
                        date
                        notes
                    }
                    .padding(.horizontal, 35)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .disabled(isShowDatePicker)
            .blur(radius: isShowDatePicker ? 10 : 0, opaque: false)
            
            if viewModel.isLoading {
                LoaderView()
            }
            
            if isShowDatePicker {
                datePicker
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: isShowDatePicker)
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $visit.image)
        }
        .onChange(of: visit.date) { _ in
            datePicked = true
        }
    }
    
    private var navBar: some View {
        ZStack {
            Text("Add visit")
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
                    viewModel.save(visit)
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .bold))
                        .opacity(visit.isAvailable ? 1 : 0.5)
                }
                .disabled(!visit.isAvailable)
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
                if let image = visit.image {
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
    
    private var zoo: some View {
        VStack {
            Text("Zoo")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $visit.zoo, isFocused: $isFocused)
        }
    }
    
    private var date: some View {
        HStack {
            let date = visit.date.formatted(.dateTime.year().month(.twoDigits).day())
            
            Text(datePicked ? date : "Visit date")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                
            Button {
                isShowDatePicker.toggle()
            } label: {
                Text("Choose")
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(height: 55)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.15))
        .font(.system(size: 20, weight: .bold))
        .cornerRadius(43)
        .overlay {
            RoundedRectangle(cornerRadius: 43)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
    }
    
    private var datePicker: some View {
        VStack {
            Button {
                isShowDatePicker = false
            } label: {
                Text("Done")
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding(.trailing)
            
            DatePicker("", selection: $visit.date, displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(.graphical)
                .padding()
                .background(.white)
                .cornerRadius(20)
        }
        .padding()
    }
    
    private var notes: some View {
        VStack {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            CustomTextField(text: $visit.notes, isFocused: $isFocused)
        }
    }
}

#Preview {
    VisitAddView(visit: Visit(isTrue: false), datePicked: false)
        .environmentObject(VisitLogViewModel())
}


