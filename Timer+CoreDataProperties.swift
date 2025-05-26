//
//  Timer+CoreDataProperties.swift
//  Allarm
//
//  Created by 전원식 on 5/23/25.
//
//

import Foundation
import CoreData


extension Timer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
        return NSFetchRequest<Timer>(entityName: "Timer")
    }

    @NSManaged public var timerLabel: String?
    @NSManaged public var timerSound: Bool
    @NSManaged public var timerTime: Int32
    @NSManaged public var timerVibration: Bool
    @NSManaged public var timerPlay: Bool
    @NSManaged public var timerId: UUID?

}

extension Timer : Identifiable {

}
