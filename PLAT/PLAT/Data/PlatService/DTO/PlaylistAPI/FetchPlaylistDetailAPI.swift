//
//  FetchPlaylistDetailAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

struct FetchPlaylistDetailResponse: Decodable {
    let playlistId: Int64
    let title: String
    let playlistImageUrl: String
    let createdAt: String
    let tracks: [TracksResponse]
    
    struct TracksResponse: Decodable {
        let orderIndex: Int
        let trackDetail: TrackDetailResponse
        
        struct TrackDetailResponse: Decodable {
            let trackId: Int64
            let isrc: String
            let createdAt: String
            let latitude: Double
            let longitude: Double
            let buildingName: String
            let address: String
            let imageUrl: String
            let content: String
            let likeCount: Int
            let isLiked: Bool
            let member: TrackMemberResponse
            
            struct TrackMemberResponse: Decodable {
                let memberId: Int64
                let memberNickname: String
                let avatar: String
            }
        }
    }
}
