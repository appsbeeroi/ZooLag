import SwiftUI

struct SplashScreen: View {
    
    @Binding var isLoaded: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Image(.splash)
                .expand()
            
            VStack(spacing: 16) {
                Image(.splashText)
                    .resizable()
                    .scaledToFit()
                    .padding(50)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: isAnimating)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 100)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoaded = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen(isLoaded: .constant(false))
}
