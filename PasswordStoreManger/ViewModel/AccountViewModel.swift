import SwiftUI

class AccountViewModel: ObservableObject {
  
    @Published var accountName: String = ""
    @Published var usernameEmail: String = ""
    @Published var password: String = ""
    @Published var strength: PasswordStrength = .weak
    
    init() {
        $password
            .map { self.evaluatePassword($0) }
            .assign(to: &$strength)
    }
    
    
    func deleteItems(user: User) {
        let viewContext = PersistenceController.shared.container.viewContext
        withAnimation {
            viewContext.delete(user)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func encryptPasswordAndSave() -> String {
        let secretKey = "Chaintech-Task@2"
        return AESCrypt.encryptECB(data: password.data(using: .utf8) ?? Data(), key: secretKey.data(using: .utf8) ?? Data())?.base64EncodedString() ?? ""
        
    }
    
    func addItem() {
        let viewContext = PersistenceController.shared.container.viewContext
        withAnimation {
            let newItem = User(context: viewContext)
            newItem.usernameEmail = usernameEmail
            newItem.date = Date()
            newItem.accountType = accountName
            newItem.password = AESCrypt.encryptECB(data: password.data(using: .utf8) ?? Data())?.base64EncodedString() ?? ""
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func generateRandomPassword(length: Int) -> String {
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+{}[]|\"<>,.?/~`-="
        let charactersArray = Array(allowedCharacters)
        
        var randomPassword = ""
        for _ in 0..<length {
            randomPassword.append(charactersArray.randomElement()!)
        }
        
        return randomPassword
    }
    
    func strengthValue(for strength: PasswordStrength) -> Double {
        switch strength {
        case .veryWeak:
            return 0.2
        case .weak:
            return 0.4
        case .moderate:
            return 0.6
        case .strong:
            return 0.8
        case .veryStrong:
            return 1.0
        }
    }
    
    private func evaluatePassword(_ password: String) -> PasswordStrength {
        let length = password.count
        let hasUpperCase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowerCase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialCharacter = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        
        let score = [hasUpperCase, hasLowerCase, hasDigit, hasSpecialCharacter].filter { $0 }.count + (length >= 8 ? 1 : 0)
        
        switch score {
        case 0...1:
            return .veryWeak
        case 2:
            return .weak
        case 3:
            return .moderate
        case 4:
            return .strong
        case 5:
            return .veryStrong
        default:
            return .veryWeak
        }
    }
}

enum PasswordStrength: String {
    case veryWeak = "Very Weak"
    case weak = "Weak"
    case moderate = "Moderate"
    case strong = "Strong"
    case veryStrong = "Very Strong"
    
    var color: Color {
        switch self {
        case .veryWeak:
            return .red
        case .weak:
            return .orange
        case .moderate:
            return .yellow
        case .strong:
            return .green
        case .veryStrong:
            return .blue
        }
    }
    
    
    
}
