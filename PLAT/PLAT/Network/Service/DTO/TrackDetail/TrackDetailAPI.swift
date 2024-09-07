//
//  TrackDetailAPI.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

struct TrackDetailRequest: Encodable {
    let isrc: String
    let imageUrl: String
    let content: String
    let latitude: Double
    let longitude: Double
}

struct TrackDetailResponse: Decodable {
    let trackId: Int64
    let isrc: String
    let createdAt: String
    let latitude: Double
    let longitude: Double
    let buildingName: String
    let address: String
    let imageUrl: String
    let context: String
    let likeCount: Int64
    let isLiked: Bool
    let member: Member
    
    struct Member: Decodable {
        let memberId: Int64
        let memberNickname: String
        let avatar: String
    }
}
