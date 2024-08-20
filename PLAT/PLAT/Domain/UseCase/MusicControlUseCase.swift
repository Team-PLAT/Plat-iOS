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
    
    var currentDuration: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    
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
        var activeMusic: Music?
        var isPaused: Bool
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case setup(isrc: String)
        case play(isrc: String)
        case togglePlayback
        case startMovePosition
        case endMovePosition
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case let .setup(isrc):
            musicController.setup {
                self.fetchMusic(isrc: isrc)
                self.musicController.play(isrc)
            }
            
            fetchCurrentPlaybackPosition()
            
        case let .play(isrc):
            cancelPublisher()
            state.isPaused = false
            self.fetchMusic(isrc: isrc)
            musicController.play(isrc)
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
            
        case .startMovePosition:
            cancelPublisher()
            
        case .endMovePosition:
            musicController.movePosition(to: currentDuration)
            fetchCurrentPlaybackPosition()
        }
    }
}

// MARK: - Fetch Music

extension MusicControlUseCase {
    
    private func fetchMusic(isrc: String) {
        Task {
            state.activeMusic = await musicController.fetchMusic(isrc)
        }
    }
}

// MARK: - Current Position

extension MusicControlUseCase {
    
    private func fetchCurrentPlaybackPosition() {
        musicController.currentDuration()
            .sink { [weak self] error in
                print(error)
                self?.cancelPublisher()
            } receiveValue: {
                self.currentDuration = $0
            }
            .store(in: &cancellables)
    }
    
    private func cancelPublisher() {
        cancellables.forEach { $0.cancel() }
    }
}
