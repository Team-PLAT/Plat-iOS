//
//  LikeTrackAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct LikeTrackRequest: Encodable {
    let trackId: Int64
    let isLiked: Bool
}

struct LikeTrackResponse: Decodable {
    let trackId: Int64
}
