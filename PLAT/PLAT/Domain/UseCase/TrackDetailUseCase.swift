//
//  TrackDetailUseCase.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

@Observable
final class TrackDetailUseCase {
    
    private(set) var state: State
    private(set) var feedTrack: [Track]
    private(set) var track: Track
    private(set) var trackId: Track.ID
    private(set) var playlist: [Playlist]
    
    private var trackService: TrackServiceInterface
    
    init(
        feedTrack: [Track],
        track: Track,
        trackService: TrackServiceInterface,
        trackId: Track.ID
    ) {
        self.feedTrack = feedTrack
        self.track = track
        self.trackService = trackService
        self.trackId = trackId
        self.playlist = [MockDataBuilder.playlist] // TODO: 실제 플레이리스트 받아오기
        
        // TODO: 교체 예정
        self.state = State(
            place: Place(
                name: "포항공과대학교",
                address: "대한민국 경상북도 포항시 남구 지곡동"
            ),
            isPaused: false
        )
    }
}

// MARK: - State

extension TrackDetailUseCase {
    
    struct State {
        var place: Place
        var isPaused: Bool
    }
}

// MARK: - Effect

extension TrackDetailUseCase {
    
    enum Effect {
        case likeTrack
        case addToPlaylist
        case deleteTrack
        case reportTrack
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .likeTrack:
            Task {
                let result = await trackService.like(track: track)
                switch result {
                case .success(let success): print("좋아요 성공!")
                case .failure(let failure): print("좋아요 실패...")
                }
            }
            
        case .addToPlaylist:
            print("기능 구현 필요")
            
        case .deleteTrack:
            print("기능 구현 필요")
            
        case .reportTrack:
            Task {
                let result = await trackService.report(track: track)
                switch result {
                case .success(let success): print("좋아요 성공!")
                case .failure(let failure): print("좋아요 실패...")
                }
            }
        }
    }
}
