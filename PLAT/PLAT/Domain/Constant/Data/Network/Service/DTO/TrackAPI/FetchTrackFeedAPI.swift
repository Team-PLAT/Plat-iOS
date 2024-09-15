//
//  FetchTrackFeedAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct FetchTrackFeedRequest: Encodable {
    let page: Int32
    let size: Int32
}

struct FetchTrackFeedResponse: Decodable {
    let trackDetails: [TrackDetails]
    
    struct TrackDetails: Decodable {
        let trackId: Int64
        let isrc: String
        let createdAt: String
        let latitude: Double
        let longitude: Double
        let buildingName: String
        let address: String
        let imageUrl: String
        let content: String
        let likeCount: Int64
        let isLiked: Bool
        let member: Member
        
        struct Member: Decodable {
            let memberId: Int64
            let memberNickname: String
            let avatar: String
        }
    }
}
