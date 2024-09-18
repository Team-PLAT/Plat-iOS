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
    
    func toTrackList() -> [Track] {
        self.trackDetails.map {
            let music = Music(
                isrc: $0.isrc,
                title: "",
                artist: "",
                albumImageUrl: "",
                duration: 0
            )
            
            let location = Location(
                latitude: $0.latitude,
                longitude: $0.longitude
            )
            
            let user = User(
                nickname: $0.member.memberNickname,
                profileImageUrl: $0.member.avatar
            )
            
            return Track(
                id: $0.trackId,
                music: music,
                location: location,
                user: user,
                content: $0.content,
                imageUrl: $0.imageUrl,
                createdDate: $0.createdAt.iso8601ToDate,
                isLike: $0.isLiked,
                isReported: false // TODO: 프론트에서 처리
            )
        }
    }
}
