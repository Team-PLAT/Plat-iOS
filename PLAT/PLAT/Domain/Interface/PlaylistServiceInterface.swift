//
//  PlaylistServiceInterface.swift
//  PLAT
//
//  Created by 조우현 on 9/12/24.
//

import Foundation

protocol PlaylistServiceInterface {
    func fetchPlaylists(page: Int, size: Int) async -> Result<[Playlist], Error>
    func fetchPlaylistDetail(playlistId: Int) async -> Result<Playlist, Error>
    func searchPlaylist(title: String, page: Int, size: Int) async -> Result<[Playlist], Error>
    func uploadPlaylist(title: String, imageUrl: String, tracks: [Track]) async -> Result<Void, Error>
    func appendTrackToPlaylist(playlistId: Int, trackId: Int) async -> Result<Void, Error>
    func updatePlaylist(playlistId: Int, title: String, imageUrl: String, tracks: [Track]) async -> Result<Void, Error>
    func deletePlaylist(playlistId: Int) async -> Result<Void, Error>
}
