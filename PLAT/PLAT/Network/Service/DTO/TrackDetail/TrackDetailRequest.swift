//
//  TrackDetailRequest.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

struct TrackDetailRequest: Encodable {
    let isrc: String
    let imageUrl: String
    let context: String
    let latitude: Double
    let longitude: Double
    let locationString: String
}
