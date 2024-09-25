//
//  PlaylistRepository.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

final class PlaylistRepository {
    
    private let client = NetworkClient.shared
    
    func fetchPlaylists(request: FetchPlaylistRequest) async -> Result<FetchPlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.fetchPlaylists.url
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = [
            URLQueryItem(name: "page", value: "\(request.page)"),
            URLQueryItem(name: "size", value: "\(request.size)")
        ]
        
        if let urlComponent = urlComponent,
           let url = urlComponent.url {
            let response: Result<BaseResponse<FetchPlaylistResponse>, Error> = await client.get(url: url)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
    
    func fetchPlaylistDetail(playlistId: Int64) async -> Result<FetchPlaylistDetailResponse, Error> {
        let url = APIs.Plat.Playlists.fetchPlaylistDetail(playlistId: playlistId).url
        let response: Result<BaseResponse<FetchPlaylistDetailResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func searchPlaylist(request: SearchPlaylistRequest) async -> Result<SearchPlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.searchPlaylist.url
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = [
            URLQueryItem(name: "title", value: "\(request.title)"),
            URLQueryItem(name: "page", value: "\(request.page)"),
            URLQueryItem(name: "size", value: "\(request.size)")
        ]
        
        if let urlComponent = urlComponent,
           let url = urlComponent.url {
            let response: Result<BaseResponse<SearchPlaylistResponse>, Error> = await client.get(url: url)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
    
    func uploadPlaylist(request: UploadPlaylistRequest) async -> Result<UploadPlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.upload.url
        let response: Result<BaseResponse<UploadPlaylistResponse>, Error>  = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func appendTrackToPlaylist(request: AppendTrackToPlaylistRequest, playlistId: Int64) async -> Result<AppendTrackToPlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.appendTrackToPlaylist(playlistId: playlistId).url
        let response: Result<BaseResponse<AppendTrackToPlaylistResponse>, Error>  = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func updatePlaylist(request: UpdatePlaylistRequest, playlistId: Int64) async -> Result<UpdatePlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.update(playlistId: playlistId).url
        let response: Result<BaseResponse<UpdatePlaylistResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func deletePlaylist(playlistId: Int64) async -> Result<DeletePlaylistResponse, Error> {
        let url = APIs.Plat.Playlists.delete(playlistId: playlistId).url
        let response: Result<BaseResponse<DeletePlaylistResponse>, Error> = await client.delete(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
