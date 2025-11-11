import SwiftUI

struct StumbView: View {
    
    let image: ImageResource
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(.white.opacity(0.15))
        .cornerRadius(35)
        .overlay {
            RoundedRectangle(cornerRadius: 35)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
    }
}
