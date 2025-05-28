//
//  StopwatchViewModel.swift
//  Allarm
//
//  Created by 최영건 on 5/22/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StopwatchViewModel {

    // MARK: - Input
    let toggleTrigger = PublishRelay<Void>()
    let resetOrLapTrigger = PublishRelay<Void>()

    // MARK: - Output
    let timerText: Observable<String>
    let isRunning: Observable<Bool>
    let lapTimes: Observable<[String]>

    // MARK: - Private
    private let _isRunning = BehaviorRelay<Bool>(value: false)
    private let _elapsedTime = BehaviorRelay<TimeInterval>(value: 0)
    private let _lapTimes = BehaviorRelay<[TimeInterval]>(value: [])

    private var timerDisposable: Disposable?
    private let disposeBag = DisposeBag()

    init() {
        let savedLapTimes = StopwatchLapManager.shared.fetchLaps()
        _lapTimes.accept(savedLapTimes)

        self.isRunning = _isRunning.asObservable()

        self.lapTimes = _lapTimes
            .map { times in
                times.enumerated().map { index, time in
                    let formatted = StopwatchViewModel.format(time: time)
                    return "랩 \(times.count - index): \(formatted)"

                }
            }

        self.timerText = _elapsedTime
            .map(StopwatchViewModel.format)

        bind()

    }

    private func bind() {
        toggleTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self._isRunning.accept(!self._isRunning.value)
                self._isRunning.value ? self.startTimer() : self.stopTimer()
            })
            .disposed(by: disposeBag)

        resetOrLapTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self._isRunning.value {
                    let currentTime = self._elapsedTime.value
                    var laps = self._lapTimes.value
                    laps.insert(currentTime, at: 0)
                    self._lapTimes.accept(laps)
                    StopwatchLapManager.shared.savedLap(time: currentTime)

                } else {
                    self._elapsedTime.accept(0)
                    self._lapTimes.accept([])

                    StopwatchLapManager.shared.deleteAllLaps()
                }
            })
            .disposed(by: disposeBag)
    }

    private func startTimer() {
        timerDisposable = Observable<Int>.interval(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self._elapsedTime.accept(self._elapsedTime.value + 0.01)
            })
    }

    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }

    private static func format(time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        let milliseconds = Int((time - floor(time)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
