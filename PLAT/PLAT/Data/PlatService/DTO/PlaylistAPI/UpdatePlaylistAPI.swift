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
}

struct UpdatePlaylistResponse: Decodable {
    let playlistId: Int64
}
