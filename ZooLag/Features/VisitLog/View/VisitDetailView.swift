import SwiftUI

struct VisitDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: VisitLogViewModel
    
    let visit: Visit
    
    @State private var isShowRemoveAlert = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .expand()
            
            VStack(spacing: 20) {
                navBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        visitDate
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
                viewModel.remove(visit)
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
                    viewModel.navigationPath.append(.add(visit))
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
    
    private var visitDate: some View {
        HStack {
            Text("Visit date")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            
            Text(visit.date.formatted(.dateTime.year().month(.twoDigits).day()))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
    
    private var image: some View {
        Image(uiImage: visit.image ?? .animalList)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 260)
            .clipped()
            .cornerRadius(100)
    }
    
    private var info: some View {
        VStack(spacing: 12) {
            Text(visit.zoo)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            Text(visit.notes)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    VisitDetailView(visit: Visit(isTrue: false))
        .environmentObject(VisitLogViewModel())
}



