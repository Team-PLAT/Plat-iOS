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
        self.state = State(selectedMusic: Music(isrc: "", title: "", artist: "", albumImageUrl: "", duration: 0))
    }
}

// MARK: - State

extension TrackAppendUseCase {
    
    struct State {
        var selectedMusic: Music
        var searchOffset: Int = 0
    }
}

// MARK: - TrackAppendUseCase Method

extension TrackAppendUseCase {
    
    /// 음악 선택
    func selectMusic(music: Music) {
        self.state.selectedMusic = music
    }
    
    /// 최근 검색어 업데이트
    func updateRecentSearchTermList(searchTerm: String) {
        trackAppendService.updateRecentSearchTermList(searchTerm: searchTerm)
    }
    
    /// 최근 검색어 불러오기
    func fetchRecentSearchTermList() -> [String] {
        return trackAppendService.fetchRecentSearchTermList()
    }
    
    /// 최근 검색어 삭제
    func removeRecentSearchTerm(index: Int) {
        trackAppendService.removeRecentSearchTerm(index: index)
    }
    
    /// 음원 검색하기
    func searchMusic(term: String, isPagination: Bool = false) async -> [Music] {
        if isPagination {
            self.state.searchOffset += 25
        } else {
            self.state.searchOffset = 0
        }
        return await trackAppendService.searchMusic(term: term, searchOffset: self.state.searchOffset)
    }
    
    /// 트랙 게시하기
    func postTrack(music: Music, context: String, location: Location) async {
        await trackAppendService.postTrack(music: music, context: context, location: location)
    }
}
