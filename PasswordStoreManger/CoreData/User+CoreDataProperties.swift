//
//  User+CoreDataProperties.swift
//  PasswordStoreManger
//
//  Created by shubam on 05/08/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var date: Date
    @NSManaged public var accountType: String
    @NSManaged public var password: String
    @NSManaged public var usernameEmail: String

}

extension User : Identifiable {

}
