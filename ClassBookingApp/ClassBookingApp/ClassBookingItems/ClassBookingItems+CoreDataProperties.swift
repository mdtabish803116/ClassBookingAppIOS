//
//  ClassBookingItems+CoreDataProperties.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//
//

import Foundation
import CoreData


extension ClassBookingItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassBookingItems> {
        return NSFetchRequest<ClassBookingItems>(entityName: "ClassBookingItems")
    }
    
    @NSManaged public var id:Int32
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var available: Int32
    @NSManaged public var booked: Bool
    @NSManaged public var added: Bool

}

extension ClassBookingItems : Identifiable {

}
