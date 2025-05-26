//
//  Alarm+CoreDataProperties.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var alarmTime: Int32
    @NSManaged public var alarmSound: Bool
    @NSManaged public var alarmVibration: Bool
    @NSManaged public var alarmLabel: String?
    @NSManaged public var alarmDate: [Int32]?
    @NSManaged public var alarmId: UUID
    @NSManaged public var alarmAmPm: String?
}

extension Alarm : Identifiable {

}
