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
            ),
            isPaused: false
        )
    }
}

// MARK: - State

extension TrackDetailUseCase {
    
    struct State {
        var place: Place
        var isPaused: Bool
    }
}

// MARK: - Effect

extension TrackDetailUseCase {
    
    enum Effect {
        case likeTrack
        case addToPlaylist
        case repeatPlayback
        case deleteTrack
        case reportTrack
        case togglePlayback
        case playPrevious
        case playNext
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .likeTrack:
            // TODO: TrackId 업데이트
            trackService.like(trackId: "")
            
        case .addToPlaylist:
            // TODO: TrackId, PlaylistId 업데이트
            trackService.addToPlaylist(
                trackId: "",
                playlistId: ""
            )
            
        case .repeatPlayback:
            musicController.repeatPlayback()
            
        case .deleteTrack:
            // TODO: TrackId 업데이트
            trackService.delete(trackId: "")
            
        case .reportTrack:
            // TODO: TrackId 업데이트
            trackService.report(trackId: "")
            
        case .togglePlayback:
            if state.isPaused {
                musicController.play(track.music)
            } else {
                musicController.pause()
            }
            state.isPaused.toggle()
            
        case .playPrevious:
            musicController.previous()
            
        case .playNext:
            musicController.next()
        }
    }
}
