//
//  MusicController.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation

@Observable
final class MusicControlUseCase {
    
    /// Apple Music or Spotify를 넣기 위한 인터페이스
    private var musicController: MusicControllerInterface
    
    private(set) var state: State
    
    init(musicController: MusicControllerInterface) {
        self.musicController = musicController
        self.state = State(
            isPaused: false
        )
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        var isPaused: Bool
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case setup
        case play
        case pause
        case resume
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .setup:
            musicController.setup()
            
        case .play:
            state.isPaused = false
            musicController.play(MockDataBuilder.music)
            
        case .pause:
            state.isPaused = true
            musicController.pause()
            
        case .resume:
            state.isPaused = false
            musicController.resume()
        }
    }
}
