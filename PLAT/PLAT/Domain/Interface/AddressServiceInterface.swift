//
//  AddressServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 9/24/24.
//

import Foundation

protocol AddressServiceInterface {
    func fetchReverseGeocode(latitude: Double, longitude: Double) async -> Result<Place, Error>
}
