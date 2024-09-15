//
//  TrackMapServiceInterface.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import Combine

protocol TrackMapServiceInterface {
    var location: AnyPublisher<Location, Never>? { get }
}
