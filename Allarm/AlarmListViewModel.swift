//
//  AlarmListViewModel.swift
//  Allarm
//
//  Created by Jin Lee on 5/22/25.
//

import UIKit
import UserNotifications

class AlarmListViewModel {
    static let instance = AlarmListViewModel() // Singleton
    
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
    
    private func requestScheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle"
        content.sound = .default
        content.badge = 1
        
        let weekdays = [Int]()
        var dateComponents = DateComponents()
        // weekday: 월1 화2 수3 목4 금5 토6 일7
        dateComponents.weekday = 2
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
