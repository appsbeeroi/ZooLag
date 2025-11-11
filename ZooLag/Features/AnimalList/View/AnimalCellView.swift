import SwiftUI

struct AnimalCellView: View {
    
    let animal: Animal
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let image = animal.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipped()
                        .cornerRadius(100)
                }
                
                VStack(spacing: 8) {
                    Text(animal.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 5) {
                        HStack(spacing: 0) {
                            if let category = animal.category {
                                Image(category.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 28)
                                
                                Text(category.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 37)
                        .padding(.horizontal, 8)
                        .background(.zlPink.opacity(0.5))
                        .cornerRadius(90)
                        .overlay {
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                        
                        HStack(spacing: 0) {
                            if let status = animal.status {
                                Image(status.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 28)
                                
                                Text(status.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 37)
                        .padding(.horizontal, 8)
                        .background(.zlPink.opacity(0.5))
                        .cornerRadius(90)
                        .overlay {
                            RoundedRectangle(cornerRadius: 90)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
