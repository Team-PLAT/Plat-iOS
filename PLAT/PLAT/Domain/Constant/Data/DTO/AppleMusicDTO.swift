//
//  AppleMusicDTO.swift
//  PLAT
//
//  Created by 조세연 on 8/21/24.
//

import Foundation

struct MusicCatalogSearchResponse: Codable {
    let data: [ResponseSong]
}

struct ResponseSong: Codable {
    let id: String
    var attributes: Attributes
}

struct Attributes: Codable {
    let durationInMillis: Int?
    let isrc: String?
    let name: String?
    let artistName: String?
    var artwork: Artwork?
}

struct Artwork: Codable {
    var url: String?
}
