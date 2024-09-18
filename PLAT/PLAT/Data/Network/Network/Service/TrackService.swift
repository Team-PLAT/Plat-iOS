//
//  TrackRepository.swift
//  PLAT
//
//  Created by 김민준 on 9/10/24.
//

import Foundation

final class TrackRepository {
    
    private let client = NetworkClient.shared
    
    func fetchTrackMap(request: FetchTrackMapRequest) async -> Result<FetchTrackMapResponse, Error> {
        let url = APIs.Plat.Tracks.fetchMap.url
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = [
            URLQueryItem(name: "startLatitude", value: "\(request.startLatitude)"),
            URLQueryItem(name: "startLongitude", value: "\(request.startLongitude)"),
            URLQueryItem(name: "endLatitude", value: "\(request.endLatitude)"),
            URLQueryItem(name: "endLongitude", value: "\(request.endLongitude)")
        ]
        if let urlComponet = urlComponent,
           let url = urlComponet.url {
            let response: Result<BaseResponse<FetchTrackMapResponse>, Error> = await client.get(url: url)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
    
    func fetchTrackFeedList(request: FetchTrackFeedRequest) async -> Result<FetchTrackFeedResponse, Error> {
        let url = APIs.Plat.Tracks.fetchFeed.url
        var urlComponet = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponet?.queryItems = [
            URLQueryItem(name: "page", value: "\(request.page)"),
            URLQueryItem(name: "size", value: "\(request.size)")
        ]
        if let urlComponet = urlComponet,
           let url = urlComponet.url {
            let response: Result<BaseResponse<FetchTrackFeedResponse>, Error> = await client.get(url: url)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
    
    func fetchTrackDetail(request: FetchTrackDetailResquest) async -> Result<FetchTrackDetailResponse, Error> {
        let url = APIs.Plat.Tracks.fetch(trackId: request.trackId).url
        let response: Result<BaseResponse<FetchTrackDetailResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func uploadTrack(request: UploadTrackRequest) async -> Result<UploadTrackResponse, Error> {
        let url = APIs.Plat.Tracks.upload.url
        let response: Result<BaseResponse<UploadTrackResponse>, Error>  = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func likeTrack(request: LikeTrackRequest) async -> Result<LikeTrackResponse, Error> {
        let url = APIs.Plat.Tracks.like(trackId: request.trackId).url
        let response: Result<BaseResponse<LikeTrackResponse>, Error>  = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func reportTrack(request: ReportTrackRequset) async -> Result<ReportTrackResponse, Error> {
        let url = APIs.Plat.Tracks.report(trackId: request.trackId).url
        let response: Result<BaseResponse<ReportTrackResponse>, Error>  = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
