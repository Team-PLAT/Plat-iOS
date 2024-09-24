//
//  AddressRepository.swift
//  PLAT
//
//  Created by 김민준 on 9/24/24.
//

import Foundation

final class AddressRepository {
    
    private let client = NetworkClient.shared
    
    func fetchReverseGeocode(request: ReverseGeocodeRequest) async -> Result<ReverseGeocodeResponse, Error> {
        let url = APIs.Plat.Address.reverseGeocode.url
        var urlComponet = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponet?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(request.latitude)"),
            URLQueryItem(name: "longitude", value: "\(request.longitude)")
        ]
        
        if let urlComponet = urlComponet,
           let url = urlComponet.url {
            let response: Result<BaseResponse<ReverseGeocodeResponse>, Error> = await client.get(url: url)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
}
