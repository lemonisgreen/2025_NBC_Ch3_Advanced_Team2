//
//  AlarmListViewModel.swift
//  Allarm
//
//  Created by Jin Lee on 5/22/25.
//

import UIKit
import UserNotifications
import CoreData
import RxSwift

class AlarmListViewModel {
    static let instance = AlarmListViewModel() // Singleton
    let disposeBag = DisposeBag()
    
    /// 제일 처음에 알림 설정을 하기 위한 함수 -> 앱이 열릴 때나 button 클릭시에 함수 호출 되도록!
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { suceess, error in
            if let error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleAllAlarms() {
        Observable<Void>.create { observer in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .flatMap { CoreDataManager.shared.fetchAlarm() }
        .subscribe(onNext: { [weak self] alarms in
            alarms.forEach { self?.scheduleNotification(for: $0) }
        })
        .disposed(by: disposeBag)
    }
    
    private func scheduleNotification(for alarm: Alarm) {
        let hour = Int(alarm.alarmTime) / 60
        let minute = Int(alarm.alarmTime) % 60
        
        let content = UNMutableNotificationContent()
        content.title = alarm.alarmLabel ?? "알람"
        content.body = "\(hour)시 \(minute)분이 되었습니다."
        content.sound = alarm.alarmSound ? .defaultRingtone : nil
        content.badge = 1
        
        guard let alarmDates = alarm.alarmDate else { return }
        for day in alarmDates {
            let weekday = Int(day)
            guard (1...7).contains(weekday) else { continue }
            
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday // 1=일요일, 2=월요일...7=토요일
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            // 현재 시간보다 이후인지 확인
            let calendar = Calendar.current
            let now = Date()
            
            // 선택한 시간의 다음 발생 시간 계산
            guard let nextDate = calendar.nextDate(
                after: now,
                matching: dateComponents,
                matchingPolicy: .nextTime
            ) else { return }
            
            // 트리거 재생성
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.weekday, .hour, .minute], from: nextDate), repeats: true)
            
            let identifier = "\(alarm.alarmId.uuidString)-\(weekday)"
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 등록 실패: \(error)")
                }
            }
        }
    }
    
    func cancelNotifications(for alarm: Alarm) {
        guard let alarmDates = alarm.alarmDate else { return }
        for day in alarmDates {
            let weekday = Int(day)
            let identifier = "\(alarm.alarmId.uuidString)-\(weekday)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}

extension UNUserNotificationCenter {
    func removeAllPendingNotificationRequests(completion: @escaping () -> Void) {
        removeAllPendingNotificationRequests()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { completion() }
    }
}
