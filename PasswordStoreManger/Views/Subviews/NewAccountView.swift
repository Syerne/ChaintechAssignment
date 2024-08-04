
import SwiftUI

struct NewAccountView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AccountViewModel
    @ObservedObject var coordinator: AppCoordinator
    @State var showingAlert: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "090b1c").opacity(0.1))
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        if viewModel.accountName.isEmpty && viewModel.usernameEmail.isEmpty && !viewModel.password.isEmpty {
                            viewModel.password = ""
                            coordinator.dismissFullScreen()
                        } else {
                            coordinator.dismissFullScreen()
                        }
                    }
                }
            VStack(spacing: 22) {
                SheetDragButtonView()
                    .padding(.top)
                GenratePasswordView(viewModel: viewModel)
                UserInputTextFieldView(type: .accountName, text: $viewModel.accountName)
                UserInputTextFieldView(type: .usernameEmail, text: $viewModel.usernameEmail)
                UserInputTextFieldView(type: .password, text: $viewModel.password)
                PasswordHintView()
                if !viewModel.password.isEmpty {
                    StrongPasswordMeterView(viewModel: viewModel)
                }
                Button(action: {
                    if !viewModel.accountName.isEmpty && !viewModel.usernameEmail.isEmpty && !viewModel.password.isEmpty {
                        showingAlert = false
                        viewModel.addItem()
                        coordinator.dismissFullScreen()
                    } else {
                        showingAlert = true
                    }
                }) {
                    addNewAccountLabel
                }
                .padding(.top, 11)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .background(
                Color(hex: "F9F9F9")
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 17.0, topTrailingRadius: 17.0, style: .continuous))
            )
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Oh ho! 😱"), message: Text("Fields should not empty. \n Please fill text"), dismissButton: .default(Text("Got it!")))
            })
            
        }
        .ignoresSafeArea()
    }
    
    private var addNewAccountLabel: some View {
        Text("Add New Account")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color(hex: "2C2C2C"))
            .cornerRadius(20)
    }
}


#Preview {
    NewAccountView(viewModel: AccountViewModel(), coordinator: AppCoordinator())
}
