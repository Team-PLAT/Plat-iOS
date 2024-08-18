//
//  Helper+FeedDateFormatter.swift
//  PLAT
//
//  Created by 조세연 on 8/16/24.
//
import Foundation

extension Date {

    /// 07/31/2024 포맷 문자열을 반환
    var monthDayYearFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
