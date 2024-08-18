//
//  Helper+StringFormatter.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

extension Double {
    
    /// 0:00 포맷으로 변환합니다.
    var musicTimeFormat: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
