//
//  Users+CoreDataProperties.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: Int64
    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

extension Users : Identifiable {

}
