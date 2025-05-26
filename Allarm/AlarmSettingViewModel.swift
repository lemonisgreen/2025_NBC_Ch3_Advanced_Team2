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
    let alarmDate = BehaviorRelay<[Int32]>(value: [])

    let saveTapped = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

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
            .subscribe(onNext: { [weak self] time, sound, vibration, label, date in
                guard let self = self else { return }

                let ampm = time < 720 ? "AM" : "PM"

                let alarmData = AlarmData( //알람 데이터 모델 생성
                    alarmTime: Int32(time),
                    alarmSound: sound,
                    alarmVibration: vibration,
                    alarmLabel: label,
                    alarmDate: date,
                    alarmId: UUID(),
                    alarmAmPm: ampm
                )

                CoreDataManage.shared.saveAlarm( //CoreData에 알람 저장
                    alarmTime: alarmData.alarmTime,
                    alarmSound: alarmData.alarmSound,
                    alarmVibration: alarmData.alarmVibration,
                    alarmLabel: alarmData.alarmLabel,
                    alarmDate: alarmData.alarmDate,
                    alarmId: alarmData.alarmId,
                    alarmAmPm: alarmData.alarmAmPm
                )
                .subscribe()
                .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
