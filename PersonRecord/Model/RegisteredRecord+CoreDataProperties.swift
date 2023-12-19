//
//  RegisteredRecord+CoreDataProperties.swift
//  PersonRecord
//
//  Created by Apple on 15/12/23.
//
//

import Foundation
import CoreData


extension RegisteredRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegisteredRecord> {
        return NSFetchRequest<RegisteredRecord>(entityName: "RegisteredRecord")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var gender: Bool
    @NSManaged public var education: String?
    @NSManaged public var dob: Date?
    @NSManaged public var photo: Data?

}

extension RegisteredRecord : Identifiable {

}
