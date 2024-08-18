//
//  SpotifyTrackDTO.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation

// MARK: - SpotifyTrackDTO

struct SpotifyTrackDTO: Codable {
    let tracks: Tracks
}

// MARK: - Tracks

struct Tracks: Codable {
    let href: String
    let items: [Item]
    let limit: Int
    let next: String
    let offset: Int
    let previous: JSONNull?
    let total: Int
}

// MARK: - Item

struct Item: Codable {
    let album: Album
    let artists: [Artist]
    let discNumber, durationMS: Int
    let explicit: Bool
    let externalIDS: ExternalIDS
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isLocal, isPlayable: Bool
    let name: String
    let popularity: Int
    let previewURL: String
    let trackNumber: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case isPlayable = "is_playable"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album

struct Album: Codable {
    let albumType: String
    let artists: [Artist]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [TrackImage]
    let isPlayable: Bool
    let name, releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case href, id, images
        case isPlayable = "is_playable"
        case name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist

struct Artist: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id, name, type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls

struct ExternalUrls: Codable {
    let spotify: String
}

// MARK: - Image

struct TrackImage: Codable {
    let height: Int
    let url: String
    let width: Int
}

// MARK: - ExternalIDS

struct ExternalIDS: Codable {
    let isrc: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {}
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
