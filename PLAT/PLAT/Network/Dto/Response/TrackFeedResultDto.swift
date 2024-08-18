//
//  TrackFeedResponsetDto.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

struct TrackFeedResponse: Decodable {
    let tracks: [Track]
    
    struct Track: Decodable {
        let trackId: Int64
        let isrc: String
        let createdAt: String
        let locationString: String
        let imageUrl: String
        let context: String
        let user: User
    }
    
    struct User: Decodable {
        let userId: Int64
        let userName: String
        let avatar: String
    }
}
