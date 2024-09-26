//
//  UploadPlaylistAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

struct UploadPlaylistRequest: Encodable {
    let title: String
    let playlistImageUrl: String
    let tracks: [TracksRequest]
    
    struct TracksRequest: Encodable {
        let trackId: Int64
        let orderIndex: Int
    }
}

struct UploadPlaylistResponse: Decodable {
    let playlistId: Int64
}
