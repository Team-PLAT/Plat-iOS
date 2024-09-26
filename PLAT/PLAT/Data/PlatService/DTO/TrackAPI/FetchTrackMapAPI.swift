//
//  FetchTrackMapAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct FetchTrackMapRequest: Encodable {
    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double
    let endLongitude: Double
}

struct FetchTrackMapResponse: Decodable {
    let tracks: [ResponseTrack]
    
    struct ResponseTrack: Decodable {
        let trackId: Int64
        let isrc: String
        let latitude: Double
        let longitude: Double
        let isLiked: Bool
    }
    
    func toTrackList() -> [Track] {
        self.tracks.map {
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
                id: 0,
                nickname: "",
                profileImageUrl: ""
            )
            
            return Track(
                id: $0.trackId,
                music: music,
                location: location,
                user: user,
                content: "",
                imageUrl: "",
                createdDate: .now,
                isLike: false,
                isReported: false // TODO: 프론트에서 처리
            )
        }
    }
}
