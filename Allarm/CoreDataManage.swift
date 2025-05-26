import CoreData
import RxSwift

class CoreDataManage {
    static let shared = CoreDataManage()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Allarm")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: - Timer
    
    // 저장 함수 - Completable(성공, 실패 방출)
    func saveTimer(timerTime: Int32, timerSound: Bool, timerVibration: Bool, timerLabel: String?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            let timer = Timer(context: self.context)
            timer.timerTime = timerTime
            timer.timerSound = timerSound
            timer.timerVibration = timerVibration
            timer.timerLabel = timerLabel
            
            do {
                try self.context.save()
                print("저장 완료")
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    // 불러오기 함수 - Single(값 1번만 방출 or 실패)
    func fetchTimer() -> Single<[Timer]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            let request = NSFetchRequest<Timer>(entityName: "Timer")
            do {
                let result = try self.context.fetch(request)
                single(.success(result))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    //MARK: - Alarm
    
    func saveAlarm(alarmTime: Int32, alarmSound: Bool, alarmVibration: Bool, alarmLabel: String?, alarmDate: [Int32], alarmId: UUID, alarmAmPm: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            let alarmEntity = Alarm(context: context)
            
            alarmEntity.alarmLabel = alarmLabel
            alarmEntity.alarmTime = alarmTime
            alarmEntity.alarmAmPm = alarmAmPm
            alarmEntity.alarmDate = alarmDate
            alarmEntity.alarmSound = alarmSound
            alarmEntity.alarmVibration = alarmVibration
            alarmEntity.alarmId = alarmId
            
            do {
                try self.context.save()
                print("저장 완료")
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    func deleteAlarm(alarmId: UUID) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
            request.predicate = NSPredicate(format: "alarmId == %@", alarmId as CVarArg)
            
            do {
                let results = try self.context.fetch(request)
                if let alarmToDelete = results.first {
                    self.context.delete(alarmToDelete)
                    try self.context.save()
                    print("삭제 완료")
                    completable(.completed)
                } else {
                    // 해당 alarmId를 가진 알람이 없을 때
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Alarm not found"])
                    completable(.error(error))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchAlarm() -> Single<[Alarm]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
            do {
                let result = try self.context.fetch(request)
                single(.success(result))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    //MARK: - 공용함수
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData: Context saved successfully.")
            } catch {
                print("CoreData: No changes to save.")
            }
        }
    }
}

