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
        var music: Music?
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
    
    /// 현재 Track을 업데이트합니다.
    func updateCurrentTrack(to track: Track) {
        state.currentTrack = track
    }
    
    /// TrackList의 음악 정보로 MusicList를 반환합니다.
    func fetchMusicList(from trackList: [Track]) async -> [Music] {
        
        var musicList: [Music] = []
        
        for track in trackList {
            if let musicInfo = await musicController.fetchMusic(with: track.music.isrc) {
                let music = Music(
                    isrc: track.music.isrc,
                    title: musicInfo.name ?? "",
                    artist: musicInfo.artistName ?? "",
                    albumImageUrl: musicInfo.url ?? "",
                    duration: Double(musicInfo.durationInMillis ?? 0)
                )
                
                musicList.append(music)
            }
        }
        
        return musicList
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
        case start(music: Music)
        case play(music: Music)
        case playPlaylist(isrcs: [String])
        case playRandomPlaylist(isrcs: [String])
        case togglePlayback
        case updatePlayer(duration: Double)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .start(music: let music):
            Task {
                // await fetchCurrentMusicInfo(music: music)
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
    
//    private func fetchCurrentMusicInfo(music: Music) async {
//        if let musicInfo = await fetchMusicInfoApi(music: music) {
//            state.music = musicInfo
//            
//            if var playingTrack = state.currentTrack {
//                playingTrack.music = state.music ?? Music(
//                    isrc: "",
//                    title: "",
//                    artist: "",
//                    albumImageUrl: "",
//                    duration: 0.0
//                )
//                state.currentTrack = playingTrack
//            }
//        }
//    }
    
//    func fetchMusicInfoApi(music: Music) async -> Music? {
//        if let musicInfo = await musicController.fetchMusic(music) {
//            return Music(
//                isrc: music.isrc,
//                title: musicInfo.name ?? music.title,
//                artist: musicInfo.artistName ?? music.artist,
//                albumImageUrl: musicInfo.url ?? music.albumImageUrl,
//                duration: (musicInfo.durationInMillis.map { Double($0) / 1000.0 }) ?? music.duration
//            )
//        }
//        return nil
//    }
}

// MARK: - Music Search

extension MusicControlUseCase {
    
    /// 음원 검색하기
    func searchMusic(term: String, isPagination: Bool = false) async -> Result<[Music], Error> {
        if isPagination {
            self.state.searchOffset += 25
        } else {
            self.state.searchOffset = 0
        }
        let result = await musicController.searchMusic(term: term, searchOffset: self.state.searchOffset)
        switch result {
        case .success(let musicList):
            return .success(musicList)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
