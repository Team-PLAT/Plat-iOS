//
//  UpdateTrackOrderAPI.swift
//  PLAT
//
//  Created by 조우현 on 10/6/24.
//

import Foundation

struct UpdateTrackOrderRequest: Encodable {
    let tracks: [TracksRequest]
    
    struct TracksRequest: Encodable {
        let trackId: Int64
        let orderIndex: Int
    }
}

struct UpdateTrackOrderResponse: Decodable {
    let playlistId: Int64
}
