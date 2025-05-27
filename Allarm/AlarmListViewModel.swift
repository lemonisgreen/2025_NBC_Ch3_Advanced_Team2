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
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 기존 알림 제거
        
        CoreDataManage.shared.fetchAlarm()
            .subscribe(onSuccess: { [weak self] alarms in
                for alarm in alarms {
                    self?.scheduleNotification(for: alarm)
                }
            })
            .disposed(by: disposeBag)
    }

    private func scheduleNotification(for alarm: Alarm) {
        let hour = Int(alarm.alarmTime) / 60
        let minute = Int(alarm.alarmTime) % 60
        
        let content = UNMutableNotificationContent()
        content.title = alarm.alarmLabel ?? "Alarm"
        content.sound = alarm.alarmSound ? .default : nil
        content.badge = 1
        
        for day in alarm.alarmDate! {
            let weekday = Int(day)
            guard (1...7).contains(weekday) else { continue }
            
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday // 1=일요일, 2=월요일...7=토요일
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
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
        for day in alarm.alarmDate! {
            let weekday = Int(day)
            let identifier = "\(alarm.alarmId.uuidString)-\(weekday)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }

    
//    private func requestScheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "title"
//        content.subtitle = "subtitle"
//        content.sound = .default
//        content.badge = 1
//        
//        let weekdays = [Int]()
//        var dateComponents = DateComponents()
//        // weekday: 월1 화2 수3 목4 금5 토6 일7
//        dateComponents.weekday = 2
//        dateComponents.hour = 18
//        dateComponents.minute = 00
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,
//            content: content,
//            trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request)
//    }
}
