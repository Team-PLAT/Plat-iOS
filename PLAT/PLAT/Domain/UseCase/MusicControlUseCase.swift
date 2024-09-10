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
    
    var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init(musicController: MusicControllerInterface) {
        self.musicController = musicController
        self.state = State(
            isStreaming: false,
            isPaused: true,
            currentDuration: 0,
            isPlayingId: 0,
            isPlayingTrack: nil
        )
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        var music: Music?
        var isStreaming: Bool
        var isPaused: Bool
        var currentDuration: Double
        var isPlayingId: Int64
        var isPlayingTrack: Track?
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case setup(music: Music)
        case play(music: Music)
        case togglePlayback
        case updatePlayer(duration: Double)
    }
    
    func effect(_ effect: Effect) async {
        switch effect {
        case let .setup(music):
            musicController.setup(music)
            await fetchCurrentMusicInfo(music: music)
            state.isStreaming = true
            state.isPaused = false
            musicController.play(music)
            fetchCurrentPlaybackPosition()
            
        case let .play(music):
            cancelPublisher()
            state.isStreaming = true
            state.isPaused = false
            musicController.play(music)
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
            
        case .updatePlayer(duration: let duration):
            musicController.updateMusicPlayer(with: duration)
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
                self.state.currentDuration = $0
            }
            .store(in: &cancellables)
    }
    
    private func cancelPublisher() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Current Music Info

extension MusicControlUseCase {
    
    private func fetchCurrentMusicInfo(music: Music) async {
        if let musicInfo = await musicController.fetchMusic(music) {
            state.music = Music(
                isrc: music.isrc,
                title: musicInfo.name ?? music.title,
                artist: musicInfo.artistName ?? music.artist,
                albumImageUrl: musicInfo.url ?? music.albumImageUrl,
                duration: (musicInfo.durationInMillis.map { Double($0) / 1000.0 }) ?? music.duration
            )
            
            if var playingTrack = state.isPlayingTrack {
                playingTrack.music = state.music ?? Music(
                    isrc: " ",
                    title: " ",
                    artist: " ",
                    albumImageUrl: " ",
                    duration: 0.0
                )
                state.isPlayingTrack = playingTrack
            }
        }
    }
    
    func fetchMusicInfoApi(music: Music) async -> Music? {
        if let musicInfo = await musicController.fetchMusic(music) {
            return Music(
                isrc: music.isrc,
                title: musicInfo.name ?? music.title,
                artist: musicInfo.artistName ?? music.artist,
                albumImageUrl: musicInfo.url ?? music.albumImageUrl,
                duration: (musicInfo.durationInMillis.map { Double($0) / 1000.0 }) ?? music.duration
            )
        }
        return nil
    }
}
