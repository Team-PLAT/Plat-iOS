//
//  Location.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import Foundation
import CoreLocation

struct Location {
    var latitude: Double
    var longitude: Double
    var place: Place?
    
    init(
        latitude: Double,
        longitude: Double,
        place: Place? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.place = place
    }
    
    /// CLLocation 타입으로 변환합니다.
    var toCLLocation: CLLocation {
        CLLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
}
