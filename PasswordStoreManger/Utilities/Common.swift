
import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .black.withAlphaComponent(0.4)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct PasswordHintView: View {
    var body: some View {
        Text("Hint: For very Strong password must contain at least one uppercase letter, one lowercase letter, one symbol, one digit, and be at least 8 characters long.")
            .font(.system(size: 10, weight: .regular, design: .default))
            .foregroundStyle(.gray)
    }
}

struct StrongPasswordMeterView: View {
    
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        if !viewModel.password.isEmpty {
            HStack {
                Text(viewModel.strength.rawValue)
                    .foregroundColor(viewModel.strength.color)
                
                ProgressView(value: viewModel.strengthValue(for: viewModel.strength))
                    .progressViewStyle(LinearProgressViewStyle(tint: viewModel.strength.color))
                    .frame(height: 10)
            }
            .padding(.top, 8)
        }
    }
}

struct SheetDragButtonView: View {
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 3.0)
                .fill(Color(hex: "E3E3E3"))
                .frame(width: 46, height: 4, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 4)
    }
}

struct GenratePasswordView: View {
    
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        Button {
            viewModel.password = viewModel.generateRandomPassword(length: 8)
        } label: {
            Text("Genrate password")
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}



struct ButtonLabel: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .bold, design: .default))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(title == "Delete" ? Color(hex: "F04646") : Color(hex: "2C2C2C"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
