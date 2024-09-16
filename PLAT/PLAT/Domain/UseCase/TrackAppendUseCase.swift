//
//  TrackAppendUseCase.swift
//  PLAT
//
//  Created by 박준우 on 8/19/24.
//

import Foundation

@Observable
final class TrackAppendUseCase {
    
    private(set) var trackAppendService: TrackAppendServiceInterface
    private(set) var state: State
    
    init(trackAppendService: TrackAppendServiceInterface) {
        self.trackAppendService = trackAppendService
        self.state = State()
    }
}

// MARK: - State

extension TrackAppendUseCase {
    
    struct State {
        
    }
}

// MARK: - TrackAppendUseCase Method

extension TrackAppendUseCase {
    
    /// 음원 검색하기
    func searchMusic(term: String) async -> [Music] {
        await trackAppendService.searchMusic(term: term)
    }
    
    /// 트랙 게시하기
    func postTrack(music: Music, context: String, location: Location) async {
        await trackAppendService.postTrack(music: music, context: context, location: location)
    }
}
