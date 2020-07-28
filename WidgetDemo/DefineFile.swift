//
//  DefineFile.swift
//  WidgetDemo
//
//  Created by 曹宇明 on 2020/7/28.
//

import Foundation

public let kUserDate = "userDate"

public let kGroupName = "group.com.maibaapp.WidgetDemo"

public func dateToString(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale.init(identifier: "zh_CN")
    let date = formatter.string(from: date)
    return date
}

public func secondBetweenDate(toDate: Date) -> CUnsignedLongLong {
    let currentDate = Date()
    let intervalCurrent = currentDate.timeIntervalSince1970
    let intervalDate = toDate.timeIntervalSince1970
    if intervalCurrent > intervalDate {
        return 0
    } else {
        return CUnsignedLongLong(intervalDate - intervalCurrent)
    }
}

public func timeBetweenDate(toDate: Date) -> String {
    let currentDate = Date()
    let intervalCurrent = currentDate.timeIntervalSince1970
    let intervalDate = toDate.timeIntervalSince1970
    if intervalCurrent > intervalDate {
        return "error"
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale.init(identifier: "zh_CN")
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate, to: toDate)
    let str = "\(components.year!)" + "年" + "\(components.month!)" + "月" + "\(components.day!)" + "日" + "\(components.hour!)" + "时" + "\(components.minute!)" + "分" + "\(components.second!)" + "秒"
    return str
}
