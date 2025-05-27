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
    func saveTimer(timerTime: Int32, timerSound: Bool, timerVibration: Bool, timerLabel: String?, timerId: UUID, timerPlay: Bool) -> Completable {
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
            timer.timerId = timerId
            timer.timerPlay = timerPlay
            
            
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
    
    //MARK: - Timer 삭제 함수

    func deleteTimer(byId id: UUID) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }

            let request: NSFetchRequest<Timer> = Timer.fetchRequest()
            request.predicate = NSPredicate(format: "timerId == %@", id as CVarArg)

            do {
                let results = try self.context.fetch(request)
                results.forEach { self.context.delete($0) }
                try self.context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
    
}
