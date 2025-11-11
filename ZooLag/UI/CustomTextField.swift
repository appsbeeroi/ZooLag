import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text("Text")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
            )
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            
            if text != "" {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .frame(height: 55)
        .padding(.horizontal, 16)
        .background(.white.opacity(0.15))
        .cornerRadius(32)
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
    }
}
