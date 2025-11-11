import SwiftUI

struct ContentView: View {
    
    @State private var isLoaded = false
    
    var body: some View {
        if isLoaded {
            TabBarView()
        } else {
            SplashScreen(isLoaded: $isLoaded)
        }
    }
}
