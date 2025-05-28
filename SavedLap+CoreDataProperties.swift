//
//  SavedLap+CoreDataProperties.swift
//  Allarm
//
//  Created by Jin Lee on 5/28/25.
//
//

import Foundation
import CoreData


extension SavedLap {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLap> {
        return NSFetchRequest<SavedLap>(entityName: "SavedLap")
    }

    @NSManaged public var time: Double
    @NSManaged public var timestamp: Date?

}

extension SavedLap : Identifiable {

}
