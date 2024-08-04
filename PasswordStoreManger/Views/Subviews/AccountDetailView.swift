import SwiftUI

struct AccountDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var user: User
    @State var isPasswordVisible = false
    @State var isEditEnable = false
    @ObservedObject var coordinator: AppCoordinator
    @State private var showingAlert = false
    @State private var Title = "Error"
    @State private var errorMessage = "Please enter your all details"
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "090b1c").opacity(0.1))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        if !user.accountType.isEmpty && !user.usernameEmail.isEmpty && !user.password.isEmpty {
                            showingAlert = false
                            user.password = viewModel.encryptPasswordAndSave()
                            try? viewContext.save()
                            coordinator.dismissFullScreen()
                        } else {
                            showingAlert = true
                        }
                    }
                }
            VStack(alignment: .leading) {
                SheetDragButtonView()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Account Details")
                            .font(Font.custom("Poppins-SemiBold", size: 19))
                            .foregroundStyle(Color(hex: "3F7DE3"))
                        Spacer()
                        if isEditEnable {
                            GenratePasswordView(viewModel: viewModel)
                        }
                    }
                    .padding(.bottom, 30)
                    AccountDetailsField(title: "Account Type", text: $user.accountType, isEditEnabled: $isEditEnable)
                    AccountDetailsField(title: "Username / Email", text: $user.usernameEmail, isEditEnabled: $isEditEnable)
                    Text("Password")
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundStyle(Color(hex: "CCCCCC"))
                    HStack {
                        if isPasswordVisible {
                            TextField(text: $viewModel.password) {
                                Text("Password")
                                    .foregroundStyle(.gray)
                            }.disabled(!isEditEnable)
                                .textInputAutocapitalization(.never)
                            
                        } else {
                            SecureField(text: $viewModel.password) {
                                Text("Password")
                                    .foregroundStyle(.gray)
                            }.disabled(!isEditEnable)
                                .textInputAutocapitalization(.never)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }, label: {
                            Image(isPasswordVisible ? "showPassword": "hidePassword")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color(hex: "CCCCCC"))
                                .frame(width: 20, height: isPasswordVisible ? 12 : 18)
                                .padding(.horizontal)
                        })
                    }
                    .padding(.bottom)
                    PasswordHintView()
                    HStack {
                        Text(viewModel.strength.rawValue)
                            .foregroundColor(viewModel.strength.color)
                        
                        ProgressView(value: viewModel.strengthValue(for: viewModel.strength))
                            .progressViewStyle(LinearProgressViewStyle(tint: viewModel.strength.color))
                            .frame(height: 10)
                    }
                    .padding(.top, 8)
                    .onAppear {
                        viewModel.password = CommonMethod.shared.convertDecryptString(decrypted: AESCrypt.decryptECB(message: user.password) ?? Data())
                    }
                    .padding(.bottom, 10)
                }
                .padding(.leading, 20)
                .padding(.trailing, 25)
                HStack(spacing: 18) {
                    Button(action: {
                        if isEditEnable == false {
                            isEditEnable = true
                        } else {
                            if !user.accountType.isEmpty && !user.usernameEmail.isEmpty && !viewModel.password.isEmpty {
                                user.password = viewModel.encryptPasswordAndSave()
                                try? viewContext.save()
                                showingAlert = false
                                coordinator.dismissFullScreen()
                            } else {
                                showingAlert = true
                            }
                        }
                    }, label: {
                        ButtonLabel(title: isEditEnable ? "Update" : "Edit")
                            .padding(.leading, 25)
                    })
                    .alert(isPresented: $showingAlert, content: {
                        Alert(title: Text(Title), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
                    })
                    
                    Button(action: {
                        viewModel.deleteItems(user: user)
                        coordinator.dismissFullScreen()
                    }, label: {
                        ButtonLabel(title: "Delete")
                            .padding(.trailing, 25)
                    })
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background {
                Color.white
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 17.0, topTrailing: 17.0), style: .continuous))
            }
        }
        .ignoresSafeArea()
    }
    
    private struct AccountDetailsField: View {
        let title: String
        @Binding var text: String
        @Binding var isEditEnabled: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(hex: "CCCCCC"))
                    .padding(.bottom, 2)
                
                TextField(text: $text) {
                    Text(title)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                .disabled(!isEditEnabled)
                .textInputAutocapitalization(.never)
                .font(Font.custom("Poppins-SemiBold", size: 16))
                .foregroundStyle(Color(hex: "333333"))
                .padding(.bottom, 27)
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController.shared
    return AccountDetailView(user: User(context: persistenceController.container.viewContext), coordinator: AppCoordinator(), viewModel: AccountViewModel())
}
