//
//  UploadTrackAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct UploadTrackRequest: Encodable {
    let isrc: String
    let imageUrl: String
    let content: String
    let latitude: Double
    let longitude: Double
}

struct UploadTrackResponse: Decodable {
    let trackId: Int64
}
