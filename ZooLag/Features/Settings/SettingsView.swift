import SwiftUI

struct SettingsView: View {
    
    @AppStorage("notificationIsEnable") var notificationIsEnable = false
    
    @Binding var showTab: Bool
    
    @State private var isToggleEnable = false
    @State private var isShowAlert = false
    @State private var isShowErrorAlert = false
    @State private var dataWasClear = false
    @State private var showWeb = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .expand()
            
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.system(size: 35, weight: .heavy))
                    .foregroundStyle(.white)
                
                VStack(spacing: 12) {
                    ForEach(SettingsSection.allCases) { section in
                        Button {
                            guard section != .notification else { return }
                            
                            if section == .about {
                                showTab = false
                                showWeb.toggle()
                            }
                            
                            if section == .clear {
                                isShowAlert.toggle()
                            }
                        } label: {
                            HStack {
                                Text(section.rawValue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                if section == .about {
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                
                                if section == .notification {
                                    Toggle("", isOn: $isToggleEnable)
                                        .tint(.yellow)
                                }
                                
                                if section == .clear {
                                    Text("Clear all")
                                        .frame(height: 35)
                                        .padding(.horizontal)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.white)
                                        .background(.red)
                                        .cornerRadius(30)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(.white.opacity(0.5), lineWidth: 1)
                                        }
                                }
                            }
                            .frame(height: 55)
                            .padding(.horizontal, 10)
                            .background(.white.opacity(0.15))
                            .cornerRadius(43)
                            .overlay {
                                RoundedRectangle(cornerRadius: 43)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 35)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            #warning("ссылка")
            if showWeb,
               let url = URL(string: "") {
                WebView(url: url) {
                    showTab = true
                    showWeb = false
                }
                .ignoresSafeArea(edges: [.bottom])
            }
        }
        .onAppear {
            isToggleEnable = notificationIsEnable
            Task {
                await NotificationAccessService.instance.requestPermission()
            }
        }
        .onChange(of: isToggleEnable) { isToggleEnable in
            Task {
                if isToggleEnable {
                    switch await NotificationAccessService.instance.currentState {
                        case .allowed:
                            notificationIsEnable = true
                        case .refused:
                            isShowErrorAlert.toggle()
                        case .undefined:
                            isShowErrorAlert.toggle()
                    }
                } else {
                    notificationIsEnable = false
                }
            }
        }
        .alert("The permission wasn't allowed. Open settings?", isPresented: $isShowErrorAlert) {
            Button("Yes") {
                openSettings()
            }
            
            Button("No") {}
        }
        .alert("Are you sure?", isPresented: $isShowAlert) {
            Button("Yes", role: .destructive) {
                Task {
                    async let _ = DefaultsStorage.instance.clear(.animal)
                    async let _ = DefaultsStorage.instance.clear(.notes)
                    async let _ = DefaultsStorage.instance.clear(.visits)
                }
            }
        }
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    SettingsView(showTab: .constant(false))
}
