//
//  TrackMapService.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import Foundation
import Combine

final class TrackMapService: TrackMapServiceInterface {
    var location: AnyPublisher<Location, Never>?
}
