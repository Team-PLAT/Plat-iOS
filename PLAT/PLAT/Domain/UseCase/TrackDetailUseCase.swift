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
        self.state = State(
            
        )
    }
}

// MARK: - State

extension TrackDetailUseCase {
    
    struct State {
        
    }
}

// MARK: - Effect

extension TrackDetailUseCase {
    
}
