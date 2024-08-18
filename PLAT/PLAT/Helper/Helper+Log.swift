//
//  Helper+Log.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation

#if DEBUG
struct Log {
    
    enum LogType: String {
        case success = "Successed"
        case fail = "Failed"
        
        var emoji: String {
            switch self {
            case .success: return "✅"
            case .fail: return "❌"
            }
        }
    }
    
    /// 테스트용 로그를 출력합니다.
    static func print(_ logType: LogType, title: String, message: String) {
        var log = ""
        log = logType.emoji + " [\(title) \(logType.rawValue)]\n" + "\(message)\n"
        Swift.print(log)
    }
}
#endif
