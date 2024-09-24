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
    
    func fetchReverseGeocode(longitude: Double, latitude: Double) {
        Task {
            let result = await addressService.fetchReverseGeocode(
                latitude: longitude,
                longitude: longitude
            )
            
            switch result {
            case .success(let place): state.place = place
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
}
