//
//  AlarmSettingModel.swift
//  Allarm
//
//  Created by 형윤 on 5/21/25.
//
import Foundation

struct AlarmData {
    var alarmTime: Int32
    var alarmSound: Bool
    var alarmVibration: Bool
    var alarmLabel: String
    var alarmDate: [Int32]
    var alarmId: UUID
    var alarmAmPm: String
}
