//
//  PlaylistServiceInterface.swift
//  PLAT
//
//  Created by 조우현 on 9/12/24.
//

import UIKit

protocol PlaylistServiceInterface {
    func fetchPlaylists(page: Int, size: Int) async -> Result<[Playlist], Error>
    func fetchPlaylistDetail(playlistId: Int) async -> Result<Playlist, Error>
    func searchPlaylist(title: String, page: Int, size: Int) async -> Result<[Playlist], Error>
    func uploadPlaylist(title: String, image: UIImage?, tracks: [Track]) async -> Result<Int64, Error>
    func appendTrackToPlaylist(playlistId: Int, trackId: Int) async -> Result<Void, Error>
    func updatePlaylist(playlistId: Int, title: String, image: UIImage?) async -> Result<Void, Error>
    func updateTrackOrder(playlistId: Int, tracks: [Track]) async -> Result<Void, Error>
    func deleteTrackFromPlaylist(playlistId: Int, trackId: Int) async -> Result<Void, Error>
    func deletePlaylist(playlistId: Int) async -> Result<Void, Error>
}
