import Foundation
import RxSwift
import RxCocoa
import AVFoundation

class TimerListViewModel {

    // MARK: - Properties
    var runningTimers = BehaviorRelay<[TimerModel]>(value: [])
    var recentTimers = BehaviorRelay<[TimerModel]>(value: [])

    private var activeTimers: [UUID: Foundation.Timer] = [:]
    private let disposeBag = DisposeBag()

    // MARK: - Public Methods

    func addTimer(_ model: TimerModel) {
        var playingModel = model
        playingModel.timerPlay = true
        saveToCoreData(playingModel)
        addRunning(playingModel)
        startTimer(playingModel, isRecent: false)
        addToRecentIfNeeded(playingModel)
    }

    func togglePlayPause(for model: TimerModel, isRecent: Bool) {
        let id = model.timerId

        if isRecent {
            var list = recentTimers.value
            guard let index = list.firstIndex(where: { $0.timerId == id }) else { return }
            list[index].timerPlay.toggle()
            recentTimers.accept(list)

            list[index].timerPlay
                ? startTimer(list[index], isRecent: true)
                : stopTimer(list[index])
        } else {
            var list = runningTimers.value
            guard let index = list.firstIndex(where: { $0.timerId == id }) else { return }
            list[index].timerPlay.toggle()
            runningTimers.accept(list)

            list[index].timerPlay
                ? startTimer(list[index], isRecent: false)
                : stopTimer(list[index])
        }
    }

    func deleteRunningTimer(at index: Int) {
        let model = runningTimers.value[index]
        var list = runningTimers.value
        list.remove(at: index)
        runningTimers.accept(list)

        CoreDataManage.shared.deleteTimer(byId: model.timerId)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func deleteRecentTimer(at index: Int) {
        var list = recentTimers.value
        let model = list[index]
        list.remove(at: index)
        recentTimers.accept(list)

        CoreDataManage.shared.deleteTimer(byId: model.timerId)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func loadInitialData() {
        CoreDataManage.shared.fetchTimer()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] timers in
                var running: [TimerModel] = []
                var recent: [TimerModel] = []

                for entity in timers {
                    let model = TimerModel(
                        timerId: entity.timerId ?? UUID(),
                        timerLabel: entity.timerLabel,
                        timerPlay: entity.timerPlay,
                        timerSound: entity.timerSound,
                        timerTime: entity.timerTime,
                        timerVibration: entity.timerVibration
                    )

                    if model.timerPlay {
                        running.append(model)
                        self?.startTimer(model, isRecent: false)
                    } else {
                        recent.append(model)
                    }
                }

                self?.runningTimers.accept(running)
                self?.recentTimers.accept(recent)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods

    private func addRunning(_ model: TimerModel) {
        var list = runningTimers.value
        list.insert(model, at: 0)
        runningTimers.accept(list)
    }


    private func startTimer(_ model: TimerModel, isRecent: Bool) {
        let id = model.timerId

        let timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (t: Foundation.Timer) in
            guard let self = self else { return }

            if isRecent {
                var list = self.recentTimers.value
                guard let index = list.firstIndex(where: { $0.timerId == id }), list[index].timerPlay else { return }
                list[index].timerTime = max(0, list[index].timerTime - 1)
                
                self.recentTimers.accept(list)

                if list[index].timerTime == 0 {
                    if list[index].timerSound {
                        self.playSound()
                    }
                    t.invalidate()
                    self.activeTimers[id] = nil
                }
            } else {
                var list = self.runningTimers.value
                guard let index = list.firstIndex(where: { $0.timerId == id }), list[index].timerPlay else { return }
                list[index].timerTime = max(0, list[index].timerTime - 1)
                
                self.runningTimers.accept(list)

                if list[index].timerTime == 0 {
                    if list[index].timerSound {
                        self.playSound()
                    }
                    t.invalidate()
                    self.activeTimers[id] = nil
                }
            }
        }

        RunLoop.main.add(timer, forMode: .common)
        activeTimers[id] = timer
    }

    private func stopTimer(_ model: TimerModel) {
        guard let timer = activeTimers[model.timerId] else { return }
        timer.invalidate()
        activeTimers[model.timerId] = nil
    }
    
    private func addToRecentIfNeeded(_ model: TimerModel) {
        
        var list = recentTimers.value

        guard !list.contains(where: { $0.timerId == model.timerId }) else { return }

        var newModel = model
        newModel.timerPlay = false
        list.insert(newModel, at: 0)
        recentTimers.accept(list)
        
    }
    

    private func saveToCoreData(_ model: TimerModel) {
        CoreDataManage.shared.saveTimer(
            timerTime: model.timerTime,
            timerSound: model.timerSound,
            timerVibration: model.timerVibration,
            timerLabel: model.timerLabel,
            timerId: model.timerId,
            timerPlay: model.timerPlay
        ).subscribe().disposed(by: disposeBag)
    }
    
    private func playSound() {
        
        AudioServicesPlaySystemSound(1005)
    }
}

struct TimerModel: Equatable {
    var timerId = UUID()
    var timerLabel: String?
    var timerPlay: Bool
    var timerSound: Bool
    var timerTime: Int32
    var timerVibration: Bool

    var timeString: String {
        let clamped = max(0, timerTime)
        return String(format: "%02d:%02d", clamped / 60, clamped % 60)
    }
}
