//
//  AlarmSettingViewModel.swift
//  Allarm
//
//  Created by 형윤 on 5/21/25.
//
import Foundation
import RxSwift
import RxCocoa

class AlarmSettingViewModel {
    let alarmTime = BehaviorRelay<Int>(value: 480)
    let alarmSound = BehaviorRelay<Bool>(value: true)
    let alarmVibration = BehaviorRelay<Bool>(value: true)
    let alarmLabel = BehaviorRelay<String>(value: "")
    let alarmDate = BehaviorRelay<[String]>(value: [])

    let saveTapped = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    // 초기 바인딩 설정
    init() {
        saveTapped
            .withLatestFrom(
                Observable.combineLatest(
                    alarmTime,
                    alarmSound,
                    alarmVibration,
                    alarmLabel,
                    alarmDate
                )
            )
            .subscribe(onNext: { time, sound, vibration, label, date in
                let alarm = AlarmData(
                    alarmTime: time,
                    alarmSound: sound,
                    alarmVibration: vibration,
                    alarmLabel: label,
                    alarmDate: date
                )
            })
            .disposed(by: disposeBag)
    }
}
