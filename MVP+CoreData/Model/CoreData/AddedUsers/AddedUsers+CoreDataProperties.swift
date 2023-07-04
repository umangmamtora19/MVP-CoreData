//
//  AddedUsers+CoreDataProperties.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//
//

import Foundation
import CoreData


extension AddedUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddedUsers> {
        return NSFetchRequest<AddedUsers>(entityName: "AddedUsers")
    }

    @NSManaged public var id: Int64
    @NSManaged public var fname: String?
    @NSManaged public var lname: String?
    @NSManaged public var profile: Data?
    @NSManaged public var addedBy: Int64

}

extension AddedUsers : Identifiable {

}
