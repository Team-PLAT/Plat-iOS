//
//  StubTrackAppendService.swift
//  PLAT
//
//  Created by 박준우 on 8/19/24.
//

import SwiftUI
import MusicKit

struct StubTrackAppendService: TrackAppendServiceInterface {
    @AppStorage("recentSearchTermList") private var recentSearchTermList: Data = Data()
    
    func updateRecentSearchTermList(searchTerm: String) {
        
        do {
            var list: [String] = []
            
            if !recentSearchTermList.isEmpty {
                let decoder = JSONDecoder()
                list = try decoder.decode([String].self, from: recentSearchTermList)
                if list.count == 10 {
                    list.removeFirst()
                }
            }
            
            list.append(searchTerm)
            let encoder = JSONEncoder()
            let listData = try encoder.encode(list)
            recentSearchTermList = listData
        } catch {
            print("updateRecentSearchTermList 실패: \(error)")
        }
    }
    
    func fetchRecentSearchTermList() -> [String] {
        
        if recentSearchTermList.isEmpty {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([String].self, from: recentSearchTermList)
        } catch {
            print("fetchRecentSearchTermList 실패: \(error)")
            return []
        }
    }
    
    func removeRecentSearchTerm(index: Int) {
        
        do {
            let decoder = JSONDecoder()
            var list = try decoder.decode([String].self, from: recentSearchTermList)
            list.remove(at: index)
            let encoder = JSONEncoder()
            let listData = try encoder.encode(list)
            recentSearchTermList = listData
        } catch {
            print("removeRecentSearchTerm 실패: \(error)")
        }
    }
}
