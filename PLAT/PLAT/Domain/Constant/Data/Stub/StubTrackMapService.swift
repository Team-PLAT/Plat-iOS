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
    
    func createPlatPlaylist(currentLocation: Location) async -> Playlist {
        // 현재 위치에서 500m 반경 내에 있는 트랙 필터링
        let filteredTracks = MockDataBuilder.trackList.filter { track in
            let trackLocation = CLLocation(latitude: track.location.latitude, longitude: track.location.longitude)
            let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            return trackLocation.distance(from: userLocation) <= 500
        }
        
        // TODO: 목 데이터 -> 실제 데이터로 변환
        let playlistTitle = MockDataBuilder.playlist[0].title
        let playlistImageUrl = MockDataBuilder.playlist[0].imageUrl
        
        let playlist = Playlist(
            title: playlistTitle,
            imageUrl: playlistImageUrl,
            trackList: filteredTracks
        )
        
        return playlist
    }
}
