
import SwiftUI

struct UserInputTextFieldView: View {
    let type: InputFieldType
    @Binding var text: String
    
    var body: some View {
        TextField(text: $text) {
            Text(type.placeholder)
        }
        .textInputAutocapitalization(.never)
        .padding(.leading)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(hex: "CBCBCB"), lineWidth: 0.6)
        }
    }
}

#Preview("UserInputTextFieldView") {
    UserInputTextFieldView(type: .accountName, text: .constant(""))
}

enum InputFieldType {
    case accountName
    case usernameEmail
    case password
    
    var placeholder: String {
        switch self {
        case .accountName:
            return "Account Name"
        case .usernameEmail:
            return "Username / Email"
        case .password:
            return "Password"
        }
    }
}

