
import Foundation
import LocalAuthentication

class LocalDeviceAuthentication {
    static let sharedInstance = LocalDeviceAuthentication()
    private init() { }
    private var context: LAContext!
    func initiateAuthentication(reason: String = "Log in to your account", cancelTitleString: String = "Cancel", _ callback: @escaping (() -> Void), failure: @escaping ((_ error: Error?) -> Void)) {
        print("initiate Authentication Check")
        context = LAContext()
        context.localizedCancelTitle = cancelTitleString
        // First check if we have the needed hardware support.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            switch context.biometryType {
            case .touchID:
                print("Touch ID Enabled")
            case .faceID:
                print("FaceID Enabled")
            case .none:
                print("Both FaceID and TouchID is disabled")
            default:
               break
            }
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                if success {
                    callback()
                } else {
                    print("context.evaluatePolicy: \(error?.localizedDescription ?? "Failed to authenticate")")
                    failure(error)
                }
            }
        } else {
            print("context.evaluatePolicy: \(error?.localizedDescription ?? "Can't evaluate policy")")
            failure(error)
            // Fall back to a asking for username and password.
            // ...
        }
    }
    func checkDeviceHasAuthentication() -> Bool {
        print("check Device Authentication Check")
        context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) { return true } else { return false }
    }
}
