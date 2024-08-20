//
//  TrackMapUseCase.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import Foundation
import MapKit

@Observable
final class TrackMapUseCase {
    
    private(set) var trackMapService: TrackMapServiceInterface
    private(set) var state: State
    private(set) var locationManager = LocationManager()
    
    init(trackMapService: TrackMapServiceInterface) {
        self.trackMapService = trackMapService
        self.state = State(trackList: [])
        
        Task {
            let location = trackMapService.currentLocation()
            let trackList = await trackMapService.fetchTrackList(currentLocation: location)
            self.state.trackList = trackList
            print(state.trackList)
        }
    }
}

// MARK: - State

extension TrackMapUseCase {
    
    struct State {
        var trackList: [Track]
    }
}

// MARK: - UseCase Method

extension TrackMapUseCase {
    
    /// 현재위치 확인하기
    func currentLocation() -> Location {
        trackMapService.currentLocation()
    }
    
    /// 서버에서 트랙 불러오기
    func fetchTrackList(currentLocation: Location) {
        Task {
            state.trackList = await trackMapService.fetchTrackList(currentLocation: currentLocation)
            print(state.trackList)
        }
    }
    
    /// 지도에 트랙별 핀 꽂기
    func insertPin(location: Location, track: Track) {
        trackMapService.insertPin(location: location, track: track)
    }
    
    /// 플레이리스트 생성하기
    func createPlatPlaylist(currentLocation: Location) async -> Playlist {
        let playlist = await self.trackMapService.createPlatPlaylist(currentLocation: currentLocation)
        return playlist
    }
}
