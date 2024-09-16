//
//  UpdateProfileStreamTypeAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct UpdateProfileStreamTypeRequest: Encodable {
    enum StreamType: String, Encodable {
        case appleMusic = "APPLE_MUSIC"
        case spotify = "SPOTIFY"
    }
    
    let streamType: StreamType
}

struct UpdateProfileStreamTypeResponse: Decodable {
    let memberId: Int64
}
