//
//  TrackMapServiceInterface.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import Combine

protocol TrackMapServiceInterface {
    func currentLocation() -> AnyPublisher<Location, Error>
    func fetchTrackList(currentLocation: Location) async -> [Track]
    func insertPin(location: Location, track: Track)
    func creatPlatPlaylist(currentLocation: Location) async -> Playlist
}
