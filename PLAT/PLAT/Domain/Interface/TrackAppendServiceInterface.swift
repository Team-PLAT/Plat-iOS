//
//  TrackAppendServiceInterface.swift
//  PLAT
//
//  Created by 박준우 on 8/19/24.
//

import Foundation

protocol TrackAppendServiceInterface {
    func updateRecentSearchTermList(searchTerm: String)
    func fetchRecentSearchTermList() -> [String]
    func removeRecentSearchTerm(index: Int)
    func postTrack(music: Music, context: String, location: Location) async
}
