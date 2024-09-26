//
//  UpdatePlaylistAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

struct UpdatePlaylistRequest: Encodable {
    let title: String
    let playlistImageUrl: String
    let tracks: [TracksRequest]
    
    struct TracksRequest: Encodable {
        let trackId: Int64
        let orderIndex: Int
    }
}

struct UpdatePlaylistResponse: Decodable {
    let playlistId: Int64
}
