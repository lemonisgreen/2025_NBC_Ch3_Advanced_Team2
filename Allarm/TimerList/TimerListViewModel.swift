import Foundation
import RxSwift
import RxCocoa
import AVFoundation

class TimerListViewModel {


    var runningTimers = BehaviorRelay<[TimerModel]>(value: [])
    var recentTimers = BehaviorRelay<[TimerModel]>(value: [])

    private var activeTimers: [UUID: Foundation.Timer] = [:]
    private let disposeBag = DisposeBag()


    // 새로운 타이머 추가 시 호출되는 함수
    func addTimer(_ model: TimerModel) {
        var playingModel = model
        playingModel.timerPlay = true // 바로 실행 상태로 설정
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

        CoreDataManager.shared.deleteTimer(byId: model.timerId)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func deleteRecentTimer(at index: Int) {
        var list = recentTimers.value
        let model = list[index]
        list.remove(at: index)
        recentTimers.accept(list)

        CoreDataManager.shared.deleteTimer(byId: model.timerId)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // 앱 시작 시 CoreData에서 타이머 데이터를 불러옴
    func loadInitialData() {
        CoreDataManager.shared.fetchTimer()
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

    // 실행 중인 타이머 목록에 추가
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
    
    // 최근 항목에 추가
    private func addToRecentIfNeeded(_ model: TimerModel) {
        
        var list = recentTimers.value

        guard !list.contains(where: { $0.timerId == model.timerId }) else { return }

        var newModel = model
        newModel.timerPlay = false
        list.insert(newModel, at: 0)
        recentTimers.accept(list)
        
    }
    
    // CoreData에 저장
    private func saveToCoreData(_ model: TimerModel) {
        CoreDataManager.shared.saveTimer(
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
