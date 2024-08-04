
import SwiftUI

struct HomeScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.date, ascending: true)],
                  animation: .default)
    private var users: FetchedResults<User>
    
    @StateObject var coordinator = AppCoordinator()
    @StateObject var viewModel = AccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Password Manager")
                .padding()
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "333333"))
                .multilineTextAlignment(.leading)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundStyle(Color(hex: "333333"))
            List(users) { user in
                AccountCell(accountType: user.accountType)
                    .onTapGesture {
                        coordinator.presentFullScreen(fullScreen: .accountDetail(user, viewModel))
                    }
                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .background(.clear)
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                coordinator.presentFullScreen(fullScreen: .newAccount(AccountViewModel()))
            }, label: {
                Image("plusButton")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "3F7DE3"))
                            .frame(width: 60, height: 60, alignment: .center)
                    }
            })
            .padding(.bottom, 30)
            .padding(.trailing, 40)
        }
        .fullScreenCover(item: $coordinator.fullScreen) { fullScreen in
            coordinator.build(fullScreen: fullScreen)
                .background(BackgroundClearView())
        }
    }
}


#Preview("HomeScreen") {
    HomeScreen(coordinator: AppCoordinator())
}
