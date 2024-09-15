//
//  Track.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import Foundation

struct Track: Identifiable {
    let id: Int64
    var music: Music
    var location: Location
    var platter: Platter
    var content: String?
    var imageUrl: String?
    var createdDate: Date
    var isLike: Bool
    var isReported: Bool
    
    init(
        id: Int64,
        music: Music,
        location: Location,
        platter: Platter,
        content: String? = nil,
        imageUrl: String? = nil,
        createdDate: Date,
        isLike: Bool = false,
        isReported: Bool = false
    ) {
        self.id = id
        self.music = music
        self.location = location
        self.platter = platter
        self.content = content
        self.imageUrl = imageUrl
        self.createdDate = createdDate
        self.isLike = isLike
        self.isReported = isReported
    }
}
