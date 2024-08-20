//
//  TrackDetailUseCase.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

@Observable
final class TrackUseCase {
    
    private(set) var state: State
    private(set) var feedTrack: [Track]
    private(set) var track: Track
    
    private var trackService: TrackServiceInterface
    
    init(
        feedTrack: [Track],
        detailTrack: Track,
        trackService: TrackServiceInterface
    ) {
        self.feedTrack = feedTrack
        self.track = detailTrack
        self.trackService = trackService
        
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

extension TrackUseCase {
    
    struct State {
        var place: Place
        var isPaused: Bool
    }
}

// MARK: - Effect

extension TrackUseCase {
    
    enum Effect {
        case fetchTrack(id: Int)
        case likeTrack
        case addToPlaylist
        case deleteTrack
        case reportTrack
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case let .fetchTrack(id):
            Task {
                if let track = await trackService.fetchTrack(with: id) {
                    self.track = track
                    print("현재 트랙!: \(track.music.title)")
                } else {
                    // TODO: 에러처리
                    Log.fail(
                        title: "Track 불러오기",
                        message: "옵셔널 값..."
                    )
                }
            }
            
        case .likeTrack:
            // TODO: TrackId 업데이트
            trackService.like(trackId: "")
            
        case .addToPlaylist:
            // TODO: TrackId, PlaylistId 업데이트
            trackService.addToPlaylist(
                trackId: "",
                playlistId: ""
            )
            
        case .deleteTrack:
            // TODO: TrackId 업데이트
            trackService.delete(trackId: "")
            
        case .reportTrack:
            // TODO: TrackId 업데이트
            trackService.report(trackId: "")
        }
    }
}

// MARK: - Fetch Track

extension TrackUseCase {
    
    func fetchTrack(id: Int) async -> Track? {
        if let track = await trackService.fetchTrack(with: id) {
            self.track = track
            return track
            
        } else {
            // TODO: 에러처리
            Log.fail(
                title: "Track 불러오기",
                message: "옵셔널 값..."
            )
        }
        
        return nil
    }
}
