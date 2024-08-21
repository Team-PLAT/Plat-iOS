//
//  AppleMusicDTO.swift
//  PLAT
//
//  Created by 조세연 on 8/21/24.
//

import Foundation

struct MusicCatalogSearchResponse: Codable {
    let data: [Song]
}

struct Song: Codable {
    let id: String
    let type: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let albumName: String?
    let genreNames: [String]?
    let trackNumber: Int?
    let releaseDate: String?
    let durationInMillis: Int?
    let isrc: String?
    let artwork: Artwork?
    let composerName: String?
    let url: String?
    let playParams: PlayParams?
    let discNumber: Int?
    let isAppleDigitalMaster: Bool?
    let hasLyrics: Bool?
    let name: String?
    let artistName: String?
}

struct Artwork: Codable {
    let width: Int?
    let height: Int?
    let url: String?
    let bgColor: String?
    let textColor1: String?
    let textColor2: String?
    let textColor3: String?
    let textColor4: String?
}

struct PlayParams: Codable {
    let id: String?
    let kind: String?
}
