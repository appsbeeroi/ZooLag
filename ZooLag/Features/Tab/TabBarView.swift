import SwiftUI

struct TabBarView: View {
    
    @State private var currentItem: TabBarItem = .list
    @State private var showTab = true
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentItem) {
                AnimalListView(showTab: $showTab)
                    .tag(TabBarItem.list)
                
                VisitLogView(showTab: $showTab)
                    .tag(TabBarItem.log)
                
                PersonalNotesView(showTab: $showTab)
                    .tag(TabBarItem.notes)
                
                SettingsView(showTab: $showTab)
                    .tag(TabBarItem.settings)
            }
            
            VStack {
                HStack(spacing: 28) {
                    ForEach(TabBarItem.allCases) { item in
                        Button {
                            currentItem = item
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.white.opacity(0.15))
                                    .overlay {
                                        Circle()
                                            .stroke(.white.opacity(0.5), lineWidth: 1)
                                    }
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(item == currentItem ? .zlYellow : .zlGray)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .opacity(showTab ? 1 : 0)
            .animation(.smooth, value: showTab)
        }
    }
}

#Preview {
    TabBarView()
}
