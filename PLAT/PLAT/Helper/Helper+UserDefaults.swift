//
//  Helper+UserDefaults.swift
//  PLAT
//
//  Created by 조우현 on 9/25/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let reportedTrackIds = "reportedTrackIds"
    }
    
    /// 신고된 Track ID 리스트를 조회합니다.
    var reportedTrackIdList: [Int64] {
        get {
            return array(forKey: Keys.reportedTrackIds) as? [Int64] ?? []
        }
        set {
            set(newValue, forKey: Keys.reportedTrackIds)
        }
    }
}
