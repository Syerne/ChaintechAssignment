
import SwiftUI

struct LaunchScreen: View {
    
    @Binding var isAppActive: Bool
    
    var body: some View {
        ZStack {
            Image("launchScreenLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        LocalDeviceAuthentication.sharedInstance.initiateAuthentication {
                            print("Success")
                            self.isAppActive = true
                        } failure: { error in
                            print("erro")
                        }

                    }
                }
        }
    }
}

#Preview {
    LaunchScreen(isAppActive: .constant(false))
}
