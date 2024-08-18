//
//  MusicControlUseCase.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation
import Combine

@Observable
final class MusicControlUseCase {
    
    /// Apple Music or Spotify를 넣기 위한 인터페이스
    private var musicController: MusicControllerInterface
    
    private(set) var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init(musicController: MusicControllerInterface) {
        self.musicController = musicController
        self.state = State(
            isPaused: false,
            currentDuration: 0
        )
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        var isPaused: Bool
        var currentDuration: Double
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case setup
        case play
        case togglePlayback
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .setup:
            musicController.setup()
            fetchCurrentPlaybackPosition()
            
        case .play:
            cancelPublisher()
            state.isPaused = false
            musicController.play(MockDataBuilder.music)
            fetchCurrentPlaybackPosition()
            
        case .togglePlayback:
            if state.isPaused {
                musicController.resume()
                fetchCurrentPlaybackPosition()
            } else {
                cancelPublisher()
                musicController.pause()
            }
            
            state.isPaused.toggle()
        }
    }
}

// MARK: - Current Position

extension MusicControlUseCase {
    
    private func fetchCurrentPlaybackPosition() {
        musicController.currentDuration()
            .sink { [weak self] currentPosition in
                self?.state.currentDuration = currentPosition
            }
            .store(in: &cancellables)
    }
    
    private func cancelPublisher() {
        cancellables.forEach { $0.cancel() }
    }
}
