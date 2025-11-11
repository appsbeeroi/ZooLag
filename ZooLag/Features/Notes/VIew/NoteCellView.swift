import SwiftUI

struct NoteCellView: View {
    
    let note: Note
    let action: () -> Void
    
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing: 8) {
                if let image = note.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipped()
                        .cornerRadius(100)
                }
                
                VStack {
                    Text(note.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(note.notes)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal)
            .frame(height: 220)
            .background(.white.opacity(0.15))
            .cornerRadius(35)
            .overlay {
                RoundedRectangle(cornerRadius: 35)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
        }
    }
}
