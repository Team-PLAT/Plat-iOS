//
//  Helper+Log.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation

#if DEBUG
struct Log {
    
    static func success(title: String, message: String) {
        let log = "✅ " + "[\(title)\n]" + "\(message)\n"
        print(log)
    }
    
    static func fail(title: String, message: String) {
        let log = "❌ " + "[\(title)\n]" + "\(message)\n"
        print(log)
    }
}
#endif
