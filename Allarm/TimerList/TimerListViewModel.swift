//  TimerListViewModel.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.

import Foundation
import RxSwift
import RxCocoa

class TimerListViewModel {

    let runningPlayPauseTapped = PublishSubject<Int>()
    let runningSoundToggleTapped = PublishSubject<Int>()
    let runningVibrateToggleTapped = PublishSubject<Int>()

    let recentPlayPauseTapped = PublishSubject<Int>()
    let recentSoundToggleTapped = PublishSubject<Int>()
    let recentVibrateToggleTapped = PublishSubject<Int>()

    let runningTimers: BehaviorRelay<[TimerModel]> = BehaviorRelay(value: [])
    let recentTimers: BehaviorRelay<[TimerModel]> = BehaviorRelay(value: [])
    let newTimerCreated = PublishSubject<TimerModel>()

    private let disposeBag = DisposeBag()
    private var activeTimers: [UUID: Timer] = [:]

    init() {
        bindInputs()
        bindNewTimer()
    }

    private func bindInputs() {
        runningPlayPauseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.runningTimers.value
                current[index].timerPlay.toggle()
                self.runningTimers.accept(current)
            })
            .disposed(by: disposeBag)

        runningSoundToggleTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.runningTimers.value
                current[index].timerSound.toggle()
                self.runningTimers.accept(current)
            })
            .disposed(by: disposeBag)

        runningVibrateToggleTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.runningTimers.value
                current[index].timerVibration.toggle()
                self.runningTimers.accept(current)
            })
            .disposed(by: disposeBag)

        recentPlayPauseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.recentTimers.value
                current[index].timerPlay.toggle()
                self.recentTimers.accept(current)
            })
            .disposed(by: disposeBag)

        recentSoundToggleTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.recentTimers.value
                current[index].timerSound.toggle()
                self.recentTimers.accept(current)
            })
            .disposed(by: disposeBag)

        recentVibrateToggleTapped
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                var current = self.recentTimers.value
                current[index].timerVibration.toggle()
                self.recentTimers.accept(current)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNewTimer() {
        newTimerCreated
            .subscribe(onNext: { [weak self] newTimer in
                self?.addRunningTimer(newTimer)
                self?.startTimer(for: newTimer)
            })
            .disposed(by: disposeBag)
    }

    private func addRunningTimer(_ model: TimerModel) {
        var current = runningTimers.value
        current.insert(model, at: 0)
        runningTimers.accept(current)
    }

    private func startTimer(for model: TimerModel) {
        var timerModel = model
        let id = model.timerId

        let timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (t: Foundation.Timer) in
            guard let self = self else { return }

            var current = self.runningTimers.value
            if let index = current.firstIndex(where: { $0.timerId == id }) {
                current[index].timerTime -= 1

                if current[index].timerTime <= 0 {
                    t.invalidate()
                    self.activeTimers[id] = nil
                }

                self.runningTimers.accept(current)
            }
        }

        RunLoop.main.add(timer, forMode: .common)
        var activeTimers: [UUID: Foundation.Timer] = [:]
    }
    
    func loadInitialData() {
        let runningMock = [
            TimerModel(timerLabel: "계란", timerPlay: true, timerSound: true, timerTime: 60, timerVibration: true),
            TimerModel(timerLabel: "라면", timerPlay: false, timerSound: false, timerTime: 180, timerVibration: true)
        ]

        let recentMock = [
            TimerModel(timerLabel: "햄버거", timerPlay: false, timerSound: true, timerTime: 120, timerVibration: false),
            TimerModel(timerLabel: "파스타", timerPlay: false, timerSound: false, timerTime: 240, timerVibration: true)
        ]

        runningTimers.accept(runningMock)
        recentTimers.accept(recentMock)
    }
}

    // MARK: - Initial Data
  
    

struct TimerModel {
    var timerId = UUID()
    var timerLabel: String?
    var timerPlay: Bool
    var timerSound: Bool
    var timerTime: Int32
    var timerVibration: Bool
    
    var timeString: String {
        let hours = timerTime / 3600
        let minutes = timerTime / 60
        let seconds = timerTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
