//
//  Playlist.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import Foundation

struct Playlist: Identifiable {
    var id = UUID()
    var title: String
    var createdDate: Date
    var imageUrl: String
    var trackList: [Track]
    
    init(
        title: String,
        createdDate: Date = .now,
        imageUrl: String,
        trackList: [Track]
    ) {
        self.title = title
        self.createdDate = createdDate
        self.imageUrl = imageUrl
        self.trackList = trackList
    }
}
