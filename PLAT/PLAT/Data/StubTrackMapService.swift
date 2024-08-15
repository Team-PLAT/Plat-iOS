//
//  StubTrackMapService.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import MapKit

struct StubTrackMapService: TrackMapServiceInterface {
    func currentLocation() -> Location {
        MockDataBuilder.currentLocation
    }
    
    func fetchTrackList(currentLocation: Location) async -> [Track] {
        MockDataBuilder.trackList
    }
    
    func insertPin(location: Location, track: Track) {
        print(#function)
    }
    
    func creatPlatPlaylist(currentLocation: Location) async -> Playlist {
        MockDataBuilder.playlist
    }
}
