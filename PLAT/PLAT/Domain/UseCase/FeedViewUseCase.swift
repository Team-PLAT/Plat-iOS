//
//  FeedViewUseCase.swift
//  PLAT
//
//  Created by 조세연 on 8/20/24.
//

import Foundation

@Observable
final class FeedViewUseCase {
    
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
            isPaused: false
        )
    }
}

// MARK: - State

extension FeedViewUseCase {
    
    struct State {
        var place: Place
        var isPaused: Bool
    }
}

// MARK: - Effect

extension FeedViewUseCase {
    
    enum FeedEffect {
        case likeTrack(at: Int)
        case addToPlaylist(at: Int, playlistId: String)
        case deleteTrack(at: Int)
        case reportTrack(at: Int)
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
