//
//  TrackMapAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct TrackMapRequest: Encodable {
    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double
    let endLongitude: Double
}

struct TrackMapResponse: Decodable {
    let tracks: [Track]
    
    struct Track: Decodable {
        let trackId: Int64
        let isrc: String
        let latitude: Double
        let longitude: Double
        let isLiked: Bool
    }
}
