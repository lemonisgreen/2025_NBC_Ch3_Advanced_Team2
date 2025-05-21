//
//  Timer+CoreDataProperties.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//
//

import Foundation
import CoreData


extension Timer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
        return NSFetchRequest<Timer>(entityName: "Timer")
    }

    @NSManaged public var timerTime: Int32
    @NSManaged public var timerSound: Bool
    @NSManaged public var timerVibration: Bool
    @NSManaged public var timerLabel: String?

}

extension Timer : Identifiable {

}
