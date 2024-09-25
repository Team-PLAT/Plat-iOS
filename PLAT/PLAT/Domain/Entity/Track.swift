//
//  Track.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import Foundation

struct Track: Identifiable {
    let id: Int64
    let order: Int
    var music: Music
    var location: Location
    var user: User
    var content: String?
    var imageUrl: String?
    var createdDate: Date
    var isLike: Bool
    var isReported: Bool
    
    init(
        id: Int64,
        order: Int,
        music: Music,
        location: Location,
        user: User,
        content: String? = nil,
        imageUrl: String? = nil,
        createdDate: Date,
        isLike: Bool = false,
        isReported: Bool = false
    ) {
        self.id = id
        self.order = order
        self.music = music
        self.location = location
        self.user = user
        self.content = content
        self.imageUrl = imageUrl
        self.createdDate = createdDate
        self.isLike = isLike
        self.isReported = isReported
    }
}
