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
    
    init(trackMapService: TrackMapServiceInterface) {
        self.trackMapService = trackMapService
        
        self.state = State(
            location: .init(latitude: 0, longitude: 0),
            trackList: []
        )
    }
}

// MARK: - State

extension TrackMapUseCase {
    
    struct State {
        var location: Location?
        var trackList: [Track]
    }
}

// MARK: - UseCase Method

extension TrackMapUseCase {
    
    /// 현재위치 확인하기
    func currentLocation() -> Location {
        .init(latitude: 0, longitude: 0)
    }
    
    /// 서버에서 트랙 불러오기
    @MainActor
    func fetchTrackList(currentLocation: Location) {
        Task {
            
        }
    }
    
    /// 지도에 트랙별 핀 꽂기
    func insertPin(location: Location, track: Track) {
        
    }
    
    /// 플레이리스트 생성하기
    @MainActor
    func createPlatPlaylist(currentLocation: Location) async -> Playlist {
        return .init(title: "", imageUrl: "", trackList: [])
    }
}
