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
        self.state = State()
    }
}

// MARK: - State

extension MusicControlUseCase {
    
    struct State {
        var isAuthorized: Bool = false
        var isStreaming: Bool = false
        var isPaused: Bool = true
        var isLoading: Bool = false
        var currentTrack: Track?
        var currentDuration: Double = 0
        var searchOffset: Int = 0
    }
}

// MARK: - UseCase Method

extension MusicControlUseCase {
    
    enum MusicError: Error {
        case fetchError
    }
    
    /// 스트리밍 계정 구독 여부를 요청합니다.
    func requestSubscription() async throws {
        startLoading()
        let result = await musicController.setup()
        // try await Task.sleep(nanoseconds: 1_000_000_000) // UX를 고려한 대기
        
        switch result {
        case let .success(isAuthorized):
            state.isAuthorized = isAuthorized
            
        case let .failure(error):
            throw error
        }
        
        stopLoading()
    }
    
    /// 음악 스트리밍을 시작합니다.
    func startMusic(with isrc: String) async -> Result<Void, Error> {
        
        let result = await musicController.fetchMusic(with: isrc)
        switch result {
        case .success(let music):
            state.currentTrack?.music = music
            musicController.play(with: isrc)
            state.isStreaming = true
            state.isPaused = false
            fetchCurrentPlaybackPosition()
            return .success(())
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 현재 Track을 업데이트합니다.
    func updateCurrentTrack(to track: Track) {
        state.currentTrack = track
    }
    
    /// TrackList의 음악 정보로 MusicList를 반환합니다.
    func fetchMusicList(from trackList: [Track]) async -> Result<[Music], Error> {
        var musicList: [Music] = []
        
        for track in trackList {
            let result = await musicController.fetchMusic(with: track.music.isrc)
            switch result {
            case .success(let music):
                musicList.append(music)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(musicList)
    }
}

// MARK: - Helper

extension MusicControlUseCase {
    
    /// 로딩을 시작합니다.
    private func startLoading() {
        state.isLoading = true
    }
    
    /// 로딩을 종료합니다.
    private func stopLoading() {
        state.isLoading = false
    }
}

// MARK: - Effect

extension MusicControlUseCase {
    
    enum Effect {
        case playPlaylist(isrcs: [String])
        case playRandomPlaylist(isrcs: [String])
        case togglePlayback
        case updatePlayer(duration: Double)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
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
