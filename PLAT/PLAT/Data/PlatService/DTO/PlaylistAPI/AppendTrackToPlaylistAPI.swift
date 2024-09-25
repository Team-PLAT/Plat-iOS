//
//  AppendTrackToPlaylistAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

struct AppendTrackToPlaylistRequest: Encodable {
    let trackId: Int64
}

struct AppendTrackToPlaylistResponse: Decodable {
    let playlistId: Int64
}
