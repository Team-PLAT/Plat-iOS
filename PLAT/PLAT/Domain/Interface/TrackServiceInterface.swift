//
//  TrackServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

protocol TrackServiceInterface {
    func like(trackId: String)
    func delete(trackId: String)
    func report(trackId: String)
    func addToPlaylist(trackId: String, playlistId: String)
}
