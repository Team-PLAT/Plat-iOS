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
    private(set) var track: Track
    
    private var trackService: TrackServiceInterface
    private var musicController: MusicControllerInterface
    
    init(
        track: Track,
        trackService: TrackServiceInterface,
        musicController: MusicControllerInterface
    ) {
        self.track = track
        self.trackService = trackService
        self.musicController = musicController
        
        // TODO: 교체 예정
        self.state = State(
            place: Place(
                name: "포항공과대학교",
                address: "대한민국 경상북도 포항시 남구 지곡동"
            )
        )
    }
}

// MARK: - State

extension TrackDetailUseCase {
    
    struct State {
        var place: Place
    }
}

// MARK: - Effect

extension TrackDetailUseCase {
    
}
