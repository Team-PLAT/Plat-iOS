//
//  TrackFeedService.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

class FeedService {
    static let shared = FeedService()
    private init() {}
    
    func searchTrackFeed(page: Int32, size: Int32) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.fetchFeed.url
        let response: Result<BaseResponse<TrackDetailResponse>, Error> = await client.get(url: url, authToken: authToken)
        print(response)
    }
    
    func searchTrackDetail(trackId: Int64) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.fetch(trackId: trackId).url
        let response: Result<BaseResponse<TrackDetailResponse>, Error> = await client.get(url: url, authToken: authToken)
        print(response)
    }
    
    func postTrackFeed(request: TrackDetailRequest) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = APIs.Plat.Tracks.upload.url
        let response: Result<BaseResponse<TrackDetailResponse>, Error>  = await client.post(url: url, body: request, authToken: authToken)
        print(response)
    }
}
