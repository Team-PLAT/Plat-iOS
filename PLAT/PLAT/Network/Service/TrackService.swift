//
//  TrackService.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct TrackService {
    static let shared = TrackService()
    
    func uploadTrack(request: UploadTrackRequest) async -> Result<UploadTrackResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.upload.url
        let response: Result<BaseResponse<UploadTrackResponse>, Error>  = await client.post(url: url, body: request, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func reportTrack(request: ReportTrackRequset) async -> Result<ReportTrackResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.report(trackId: request.trackId).url
        let response: Result<BaseResponse<ReportTrackResponse>, Error>  = await client.post(url: url, body: request, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func likeTrack(request: LikeTrackRequest) async -> Result<LikeTrackResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.like(trackId: request.trackId).url
        let response: Result<BaseResponse<LikeTrackResponse>, Error>  = await client.post(url: url, body: request, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTrackDetail(request: FetchTrackDetailResquest) async -> Result<FetchTrackDetailResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.fetch(trackId: request.trackId).url
        let response: Result<BaseResponse<FetchTrackDetailResponse>, Error> = await client.get(url: url, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func fetchTrackMap(request: FetchTrackMapRequest) async -> Result<FetchTrackMapResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.fetchMap.url
        var urlComponet = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponet?.queryItems = [
            URLQueryItem(name: "startLatitude", value: "\(request.startLatitude)"),
            URLQueryItem(name: "startLongitude", value: "\(request.startLongitude)"),
            URLQueryItem(name: "endLatitude", value: "\(request.endLatitude)"),
            URLQueryItem(name: "endLongitude", value: "\(request.endLongitude)")
        ]
        let response: Result<BaseResponse<FetchTrackMapResponse>, Error> = await client.get(url: urlComponet!.url!, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTrackFeed(request: FetchTrackFeedRequest) async -> Result<FetchTrackFeedResponse, Error> {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.fetchFeed.url
        var urlComponet = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponet?.queryItems = [
            URLQueryItem(name: "page", value: "\(request.page)"),
            URLQueryItem(name: "size", value: "\(request.size)")
        ]
        let response: Result<BaseResponse<FetchTrackFeedResponse>, Error> = await client.get(url: urlComponet!.url!, authToken: authToken)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
