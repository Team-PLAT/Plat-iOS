//
//  Helper+DateFormatter.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

extension Date {
    
    /// 2024.08.15 포맷 문자열을 반환합니다.
    var yearMonthDayFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    /// 07/31/2024 포맷 문자열을 반환
    var monthDayYearFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}

extension String {
    
    /// 문자열 ISO 8601 타입을 Date 타입으로 변환합니다.
    var iso8601ToDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds
        ]
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return .now
        }
    }
}
