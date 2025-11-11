import SwiftUI

struct LoaderView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 60, height: 60)
            .foregroundStyle(.white.opacity(0.15))
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.zlPink, lineWidth: 1)
                    
                    ProgressView()
                }
            }
    }
}

#Preview {
    LoaderView()
}
