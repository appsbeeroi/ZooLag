import SwiftUI

struct StrokedView: View {
    
    let text: String
    let color: Color
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 0, y: 1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 1, y: 1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: -1, y: -1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 0, y: 1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: -1, y: 1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 1, y: -1)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(color)
        }
    }
}
