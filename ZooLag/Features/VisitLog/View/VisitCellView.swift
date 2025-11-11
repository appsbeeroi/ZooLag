import SwiftUI

struct VisitCellView: View {
    
    let visit: Visit
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let image = visit.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipped()
                        .cornerRadius(100)
                }
                
                VStack(spacing: 0) {
                    Text(visit.zoo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(visit.notes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .frame(height: 120)
            .padding(.horizontal, 14)
            .background(.white.opacity(0.15))
            .cornerRadius(68)
            .overlay {
                RoundedRectangle(cornerRadius: 68)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
        }
    }
}
