//
//  FetchTrackDetailAPI.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

struct FetchTrackDetailResquest: Encodable {
    let trackId: Int64
}

struct FetchTrackDetailResponse: Decodable {
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
    
    /// Track으로 변환합니다.
    func toTrack() -> Track {
        let music = Music(
            isrc: self.isrc,
            title: "",
            artist: "",
            albumImageUrl: "",
            duration: 0
        )
        
        let location = Location(
            latitude: self.latitude,
            longitude: self.longitude
        )
        
        return Track(
            id: self.trackId,
            music: music,
            location: location,
            user: User(
                id: Int(self.member.memberId),
                nickname: self.member.memberNickname,
                profileImageUrl: self.member.avatar
            ),
            content: self.content,
            imageUrl: self.imageUrl,
            createdDate: self.createdAt.iso8601ToDate,
            isLike: self.isLiked,
            isReported: false // TODO: 나중에 서버에서 받아서 처리
        )
    }
}
