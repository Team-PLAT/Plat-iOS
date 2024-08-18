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
        self.state = State()
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case setup
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .setup:
            musicController.setup()
        }
    }
}
