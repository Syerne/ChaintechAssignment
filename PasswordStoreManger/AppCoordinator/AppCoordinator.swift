import SwiftUI

enum FullScreen: Identifiable {
    case newAccount(AccountViewModel)
    case accountDetail(User, AccountViewModel)
    var id: Int {
        switch self {
        case .newAccount(_):
            1
        case .accountDetail(_,_):
            2
        }
    }
}

class AppCoordinator: ObservableObject {
    
    @Published var fullScreen :FullScreen?
    
    func presentFullScreen(fullScreen :FullScreen) {
        self.fullScreen = fullScreen
    }
    
    func dismissFullScreen() {
        self.fullScreen = nil
    }
    
    @ViewBuilder
    func build(fullScreen: FullScreen) ->  some View {
        switch fullScreen {
        case .newAccount(let vm):
            NewAccountView(viewModel: vm, coordinator: self)
        case .accountDetail(let user, let vm):
            AccountDetailView(user: user, coordinator: self, viewModel: vm)
        }
    }
}
