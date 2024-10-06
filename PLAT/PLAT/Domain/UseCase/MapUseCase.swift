//
//  MapUseCase.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation

@Observable
final class MapUseCase {
    
    private let addressService: AddressServiceInterface
    
    private(set) var state: State
    
    init(addressService: AddressServiceInterface) {
        self.addressService = addressService
        self.state = State()
    }
}

// MARK: - State

extension MapUseCase {
    
    struct State {
        var place: Place?
    }
}

// MARK: - UseCase Method

extension MapUseCase {
    
    /// 좌표값에 따라 역지오코딩 값을 반환합니다.
    func fetchReverGeocode(latitude: Double, longitude: Double) async -> Result<Place, Error> {
        let result = await addressService.fetchReverseGeocode(
            latitude: latitude,
            longitude: longitude
        )
        
        switch result {
        case .success(let place): return .success(place)
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 좌표값에 따라 역지오코딩 값을 업데이트합니다.
    func updateReverseGeocode(latitude: Double, longitude: Double) {
        Task {
            let result = await addressService.fetchReverseGeocode(
                latitude: latitude,
                longitude: longitude
            )
            
            switch result {
            case .success(let place): state.place = place
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
}
