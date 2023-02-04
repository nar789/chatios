//
//  Date+Extension.swift
//  fantoo
//
//  Created by mkapps on 2022/05/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

extension Date {
    func checkOverTime(minutes:Int) -> Bool {
        let time = Int(self.timeIntervalSince(Date())) / 60
        print("abs(time) : \(abs(time))")
        if abs(time) > minutes {
            return true
        }
        
        return false
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = (earliest == self) ? fromDate : self
        
        let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        if year >= 2 {
            return String(format: "YearsAgo".localized, String(year))
        }
        else if year >= 1 {
            return "YearAgo".localized
        }
        else if month >= 2 {
            return String(format: "MonthsAgo".localized, String(month))
        }
        else if month >= 1 {
            return "MonthAgo".localized
        }
        else  if week >= 2 {
            return String(format: "WeeksAgo".localized, String(week))
        }
        else if week >= 1 {
            return "WeekAgo".localized
        }
        else if day >= 2 {
            return String(format: "DaysAgo".localized, String(day))
        }
        else if day >= 1 {
            return "DayAgo".localized
        }
        else if hours >= 2 {
            return String(format: "HoursAgo".localized, String(hours))
        }
        else if hours >= 1 {
            return "HourAgo".localized
        }
        else if minutes >= 2 {
            return String(format: "MinutesAgo".localized, String(minutes))
        }
        else if minutes >= 1 {
            return "MinuteAgo".localized
        }
        else if seconds >= 3 {
            return String(format: "SecondsAgo".localized, String(seconds))
        }
        else {
            return "JustNow".localized
        }
    }
    
    func toString(_ format:String = "MMM dd, yyyy hh:mm:ss a") -> String {
        let df = DateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        df.dateFormat = format
        
        return df.string(from: self)
    }
    
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
