//
//  AddressServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 9/24/24.
//

import Foundation

final class AddressServiceImpl: AddressServiceInterface {
    
    private let addressRepository = AddressRepository()
    
    /// 역지오코딩 후 주소를 반환합니다.
    func fetchReverseGeocode(latitude: Double, longitude: Double) async -> Result<Place, any Error> {
        let requst = ReverseGeocodeRequest(latitude: latitude, longitude: longitude)
        let result = await addressRepository.fetchReverseGeocode(request: requst)
        switch result {
        case .success(let reverseGeocodeResponse):
            return .success(Place(address: reverseGeocodeResponse.address))
        case .failure(let error):
            return .failure(error)
        }
    }
}
