//
//  Music.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import Foundation

struct Music {
    var isrc: String
    var title: String
    var artist: String
    var albumImageUrl: String
    var duration: Double
    
    init(
        isrc: String,
        title: String,
        artist: String,
        albumImageUrl: String,
        duration: Double
    ) {
        self.isrc = isrc
        self.title = title
        self.artist = artist
        self.albumImageUrl = albumImageUrl
        self.duration = duration
    }
}
