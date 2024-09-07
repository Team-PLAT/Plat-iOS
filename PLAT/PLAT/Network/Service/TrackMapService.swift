//
//  TrackMapService.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct MapService {
    static let shared = MapService()
    
    static func searchTrackMap(request: TrackMapRequest) async -> Result<TrackMapResponse, Error> {
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
        let response: Result<BaseResponse<TrackMapResponse>, Error> = await client.get(url: urlComponet!.url!, authToken: authToken)
        print(response)
        do {
            return try .success(response.get().result)
        } catch {
            print(error)
            return .failure(error)
        }
    }
}
