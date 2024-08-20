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
    
    func searchTrackFeed() async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = URL(string: Config.baseURL + "/tracks/feeds")!
        let response: Result<BaseResponse<TrackDetailResponse>, Error> = await client.get(url: url, authToken: authToken)
        print(response)
    }
    
    func searchTrackDetail(trackId: Int64) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = URL(string: "\(Config.baseURL)/tracks/\(trackId)")!
        let response: Result<BaseResponse<TrackDetailResponse>, Error> = await client.get(url: url, authToken: authToken)
        print(response)
    }
    
    func postTrackFeed(trackDetail: TrackDetailRequest) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        let url = URL(string: "\(Config.baseURL)/tracks")!
        let response: Result<BaseResponse<TrackDetailResponse>, Error>  = await client.post(url: url, body: trackDetail, authToken: authToken)
        print(response)
    }
}
