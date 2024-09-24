//
//  TrackUseCase.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

@Observable
final class TrackUseCase {
    
    private var trackService: TrackServiceInterface
    
    private(set) var state: State
    private(set) var currentTrack: Track
    private(set) var mapTrackList: [Track]
    private(set) var feedTrackList: [Track]
    
    init(trackService: TrackServiceInterface) {
        self.state = State()
        self.mapTrackList = []
        self.feedTrackList = []
        self.currentTrack = MockDataBuilder.track
        self.trackService = trackService
    }
}

// MARK: - State

extension TrackUseCase {
    
    struct State {
        
    }
}

// MARK: - Effect

extension TrackUseCase {
    
    enum Effect {
        case fetchMapTrackList(rectLocation: RectLocation)
        case fetchFeedTrackList(page: Int)
        case fetchCurrentTrack(id: Int)
        case uploadTrack(isrc: String, imageData: Data, content: String?, location: Location)
        case likeTrack(trackId: Int, isLike: Bool)
        case reportTrack(trackId: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .fetchMapTrackList(let rectLocation):
            Task {
                let result = await trackService.fetchTrackList(rectLocation: rectLocation)
                switch result {
                case .success(let trackList): self.mapTrackList = trackList
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .fetchFeedTrackList(let page):
            Task {
                let result = await trackService.fetchTrackList(page: page)
                switch result {
                case .success(let trackList): self.feedTrackList = trackList
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .fetchCurrentTrack(let id):
            Task {
                let result = await trackService.fetchCurrent(trackId: id)
                switch result {
                case .success(let track): self.currentTrack = track
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .uploadTrack(let isrc, let imageData, let content, let location):
            Task {
                let uploadTrackResult = await trackService.uploadTrack(
                    isrc: isrc,
                    imageData: imageData,
                    content: content,
                    location: location
                )
                switch uploadTrackResult {
                case .success: break
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .likeTrack(let trackId, let isLike):
            Task {
                let result = await trackService.like(trackId: trackId, isLike: isLike)
                switch result {
                case .success: break
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .reportTrack(let trackId):
            Task {
                let result = await trackService.report(trackId: trackId)
                switch result {
                case .success: break
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
        }
    }
}
