
import SwiftUI

@main
struct PasswordStoreMangerApp: App {
    let persistenceController = PersistenceController.shared
    @State var isAppActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAppActive {
                HomeScreen()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                LaunchScreen(isAppActive: $isAppActive)
            }
        }
    }
}
