//
//  StubTrackMapService.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import Combine

struct StubTrackMapService: TrackMapServiceInterface {
    var location: AnyPublisher<Location, Never>?
}
