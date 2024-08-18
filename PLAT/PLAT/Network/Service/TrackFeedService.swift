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
        do {
            let url = URL(string: Config.baseURL + "/tracks/feeds")!
            let response: BaseResponse<TrackFeedResponse> = try await client.get(url: url, authToken: authToken)
            print(response)
            // 우리가 구현한 모델에 연결
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func searchTrackDetail(trackId: Int64) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        do {
            let url = URL(string: "\(Config.baseURL)/tracks/\(trackId)")!
            let response: BaseResponse<TrackFeedResponse> = try await client.get(url: url, authToken: authToken)
            print(response)
            // 우리가 구현한 모델에 연결
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func postTrackFeed(trackDetail: TrackDetailDto) async {
        let client = NetworkClient()
        let authToken = "tokenishere"
        do {
            let url = URL(string: "\(Config.baseURL)/tracks")!
            let response: BaseResponse<TrackFeedResponse> = try await client.post(url: url, body: trackDetail, authToken: authToken)
            print(response)
            // 우리가 구현한 모델에 연결
        } catch {
            print(error.localizedDescription)
        }
    }
}
