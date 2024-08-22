//
//  FeedTrackServiceInterface.swift
//  PLAT
//
//  Created by 조세연 on 8/20/24.
//

import Foundation

protocol FeedTrackServiceInterface {
    func likeTrack(at index: Int)
    func deleteTrack(at index: Int)
    func reportTrack(at index: Int)
    func addToPlaylist(at index: Int, playlistId: String)
}
