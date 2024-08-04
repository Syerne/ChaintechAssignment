
import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accountType: String
    @NSManaged public var date: Date
    @NSManaged public var password: String
    @NSManaged public var usernameEmail: String

}

extension User : Identifiable {

}
