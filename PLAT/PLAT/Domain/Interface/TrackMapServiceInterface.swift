//
//  TrackMapServiceInterface.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import MapKit

protocol TrackMapServiceInterface {
    func currentLocation() -> Location
    func fetchTrackList(currentLocation: Location) async -> [Track]
    func insertPin(location: Location, track: Track)
    func createPlatPlaylist(currentLocation: Location) async -> Playlist
}
