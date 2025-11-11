import SwiftUI

struct VisitLogView: View {
    
    @StateObject private var viewModel = VisitLogViewModel()
    
    @Binding var showTab: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.background)
                    .expand()
                
                VStack(spacing: 20) {
                    Text("Visit Log")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    if viewModel.visits.isEmpty {
                      stumb
                    } else {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 24) {
                                    visits
                                    
                                    ForEach(viewModel.visits) { visit in
                                        VisitCellView(visit: visit) {
                                            showTab = false
                                            viewModel.navigationPath.append(.detail(visit))
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
            .navigationDestination(for: VisitLogScreen.self) { screen in
                switch screen {
                    case .add(let visit):
                        VisitAddView(visit: visit, datePicked: visit.image != nil)
                    case .detail(let visit):
                        VisitDetailView(visit: visit)
                }
            }
            .onAppear {
                showTab = true
                viewModel.downloadVisits()
            }
        }
        .environmentObject(viewModel)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            StumbView(
                image: .visitLog,
                title: "Your visits have not been added yet",
                subtitle: "Start keeping a journal and save your impressions!"
            )
            
            addButton
        }
        .frame(maxHeight: .infinity)
        .padding(.bottom, 100)
        .padding(.horizontal, 35)
    }
    
    private var visits: some View {
        HStack {
            HStack {
                Image(.visitLog)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                
                Text("YOUR VISITS:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(viewModel.visits.count.formatted())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 86)
        .padding(.horizontal, 16)
        .background(.white.opacity(0.15))
        .cornerRadius(68)
        .overlay {
            RoundedRectangle(cornerRadius: 68)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
    }
    
    private var addButton: some View {
        Button {
            showTab = false
            viewModel.navigationPath.append(.add(Visit(isTrue: true)))
        } label: {
            Text("Add visit")
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
    VisitLogView(showTab: .constant(false))
}


