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
    
    // MARK: - Tracks

    struct Tracks: Codable {
        let items: [Item]
    }

    // MARK: - Item

    struct Item: Codable {
        let album: Album
        let artists: [Artist]
        let durationMS: Int
        let externalIDS: ExternalIDS
        let name: String
        let uri: String
        
        enum CodingKeys: String, CodingKey {
            case album, artists
            case durationMS = "duration_ms"
            case externalIDS = "external_ids"
            case name
            case uri
        }
    }

    // MARK: - Album

    struct Album: Codable {
        let artists: [Artist]
        let images: [TrackImage]
        
        enum CodingKeys: String, CodingKey {
            case artists
            case images
        }
    }

    // MARK: - Artist

    struct Artist: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
    }

    // MARK: - Image

    struct TrackImage: Codable {
        let url: String
    }

    // MARK: - ExternalIDS

    struct ExternalIDS: Codable {
        let isrc: String
    }
}
