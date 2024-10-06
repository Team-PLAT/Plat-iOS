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
        static let recentSearchTermList = "recentSearchTermList"
    }
    
    var reportedTrackIdList: [Int64] {
        get {
            return array(forKey: Keys.reportedTrackIds) as? [Int64] ?? []
        }
        set {
            set(newValue, forKey: Keys.reportedTrackIds)
        }
    }
    
    var recentSearchTermList: [String] {
        get {
            return array(forKey: Keys.recentSearchTermList) as? [String] ?? []
        }
        set {
            set(newValue, forKey: Keys.recentSearchTermList)
        }
    }
}
