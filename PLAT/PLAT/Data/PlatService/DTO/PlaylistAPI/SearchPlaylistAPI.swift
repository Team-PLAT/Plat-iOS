//
//  SearchPlaylistAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

struct SearchPlaylistRequest: Encodable {
    let title: String
    let page: Int
    let size: Int
}

struct SearchPlaylistResponse: Decodable {
    let playlists: [PlaylistsResponse]
    
    struct PlaylistsResponse: Decodable {
        let playlistId: Int64
        let title: String
        let playlistImageUrl: String
        let createdAt: String
        let uploaderNicknames: [String]
    }
}
