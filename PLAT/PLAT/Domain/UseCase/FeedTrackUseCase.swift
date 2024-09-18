//
//  FeedTrackUseCase.swift
//  PLAT
//
//  Created by 조세연 on 8/20/24.
//

import Foundation

@Observable
final class FeedTrackUseCase {
    
    private(set) var state: State
    private(set) var feedTrack: [Track]
    
    private var feedTrackService: FeedTrackServiceInterface
    
    init(
        feedTrack: [Track],
        feedTrackService: FeedTrackServiceInterface
    ) {
        self.feedTrack = feedTrack
        self.feedTrackService = feedTrackService
        
        // TODO: 교체 예정
        self.state = State(
            place: Place(
                name: "",
                address: "포항시 남구 지곡동"
            ),
            isPaused: true
        )
    }
}

// MARK: - State

extension FeedTrackUseCase {
    
    struct State {
        var place: Place
        var isPaused: Bool
    }
}

// MARK: - Effect

extension FeedTrackUseCase {
    
    enum FeedEffect {
        case likeTrack(index: Int)
        case addToPlaylist(index: Int, playlistId: String)
        case deleteTrack(index: Int)
        case reportTrack(index: Int)
    }
    
    func effect(_ effect: FeedEffect) {
        switch effect {
        case .likeTrack(let index):
            feedTrackService.likeTrack(at: index)
            
        case .addToPlaylist(let index, let playlistId):
            feedTrackService.addToPlaylist(at: index, playlistId: playlistId)
            
        case .deleteTrack(let index):
            feedTrackService.deleteTrack(at: index)
            
        case .reportTrack(let index):
            feedTrackService.reportTrack(at: index)
        }
    }
}
