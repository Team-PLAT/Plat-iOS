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
    
    private var musicController: MusicControllerInterface
    
    var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init(musicController: MusicControllerInterface) {
        self.musicController = musicController
        self.state = State(
            isStreaming: false,
            isPaused: true,
            isLoading: false,
            currentDuration: 0,
            isPlayingTrack: nil,
            status: false
        )
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        var music: Music?
        var isStreaming: Bool
        var isPaused: Bool
        var isLoading: Bool
        var currentDuration: Double
        var isPlayingTrack: Track?
        var status: Bool
        var searchOffset: Int = 0
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case request
        case setup(music: Music)
        case play(music: Music)
        case playPlaylist(isrcs: [String])
        case playRandomPlaylist(isrcs: [String])
        case togglePlayback
        case updatePlayer(duration: Double)
        case updatePlayingTrack(track: Track)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .request:
            Task {
                state.isLoading = true
                state.status = await musicController.setup()
                state.isLoading = false
            }
            
        case let .setup(music):
            Task {
                state.status = await musicController.setup()
                await fetchCurrentMusicInfo(music: music)
                musicController.play(music)
            }
            state.isStreaming = true
            state.isPaused = false
            fetchCurrentPlaybackPosition()
            
        case let .play(music):
            cancelPublisher()
            state.isStreaming = true
            state.isPaused = false
            musicController.play(music)
            fetchCurrentPlaybackPosition()
            
        case .playPlaylist(let isrcs):
            musicController.playPlaylist(with: isrcs)
            
        case .playRandomPlaylist(let isrcs):
            musicController.playRandomPlaylist(with: isrcs)
            
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
            
        case .updatePlayingTrack(track: let track):
            state.isPlayingTrack = track
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
        if let musicInfo = await fetchMusicInfoApi(music: music) {
            state.music = musicInfo
            
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

// MARK: - Music Search

extension MusicControlUseCase {
    
    /// 음원 검색하기
    func searchMusic(term: String, isPagination: Bool = false) async -> [Music] {
        if isPagination {
            self.state.searchOffset += 25
        } else {
            self.state.searchOffset = 0
        }
        return await musicController.searchMusic(term: term, searchOffset: self.state.searchOffset)
    }
}
