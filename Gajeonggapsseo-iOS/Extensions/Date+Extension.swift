//
//  Date+Extension.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/29/24.
//

import Foundation

extension Date {
    func toYearMonthDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
    
    static func fromYearMonthDayString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.date(from: dateString)
    }
    
    static func fromOperationTimeToDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let opertationTimeDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:00"
        return dateFormatter.string(from: opertationTimeDate ?? Date())
    }
    
    static func fromOperatingHoursToDateString(_ dateString: String) -> String {
        var formattedString = dateString
        formattedString = formattedString.replacingOccurrences(of: "시", with: ":00")
        formattedString = formattedString.replacingOccurrences(of: "~", with: " ~ ")
        return formattedString
    }
}
