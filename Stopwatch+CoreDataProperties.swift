//
//  Stopwatch+CoreDataProperties.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//
//

import Foundation
import CoreData


extension Stopwatch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stopwatch> {
        return NSFetchRequest<Stopwatch>(entityName: "Stopwatch")
    }

    @NSManaged public var stopwatchLapTime: Int32
    @NSManaged public var stopwatchStartTime: Int32
    @NSManaged public var stopwatchEndTime: Int32
    @NSManaged public var stopwatchTotalTime: Int32

}

extension Stopwatch : Identifiable {

}
