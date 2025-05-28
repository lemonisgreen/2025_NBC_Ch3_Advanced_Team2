//
//  StopwatchLapManager.swift
//  Allarm
//
//  Created by Jin Lee on 5/28/25.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class StopwatchLapManager {
    static let shared = StopwatchLapManager()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Allarm")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data 로딩 실패: \(error)")
            }
        }
    }

    // 랩 타임 저장
    func savedLap(time: TimeInterval) {
        let newLap = SavedLap(context: context)
        newLap.time = time
        newLap.timestamp = Date()

        do {
            try context.save()
        } catch {
            print("랩 저장 실패: \(error)")
        }
    }

    // 랩 타임 불러오기
    func fetchLaps() -> [TimeInterval] {
        let request: NSFetchRequest<SavedLap> = SavedLap.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        do {
            let records = try context.fetch(request)
            return records.map { $0.time }
        } catch {
            print("랩 불러오기 실패: \(error)")
            return []
        }

    }

    // 모든 랩 기록 삭제
    func deleteAllLaps() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedLap.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("랩 삭제 실패: \(error)")
        }
    }

}
