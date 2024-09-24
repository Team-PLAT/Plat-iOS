//
//  ReverseGeocodeAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/24/24.
//

import Foundation

struct ReverseGeocodeRequest: Encodable {
    let latitude: Double
    let longitude: Double
}

struct ReverseGeocodeResponse: Decodable {
    let address: String
}
