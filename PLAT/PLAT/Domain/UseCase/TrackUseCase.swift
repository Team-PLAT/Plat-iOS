//
//  TrackUseCase.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import UIKit

@Observable
final class TrackUseCase {
    
    private var trackService: TrackServiceInterface
    
    private(set) var currentTrack: Track
    private(set) var mapTrackList: [Track]
    private(set) var feedTrackList: [Track]
    private(set) var selectedTrackAppendMusic: Music
    
    private(set) var feedListPage: Int
    private(set) var feedListHasNext: Bool
    
    init(trackService: TrackServiceInterface) {
        self.mapTrackList = []
        self.feedTrackList = []
        self.currentTrack = MockDataBuilder.track
        self.trackService = trackService
        self.selectedTrackAppendMusic = Music(
            isrc: "",
            title: "",
            artist: "",
            albumImageUrl: "",
            duration: 0
        )
        
        self.feedListPage = 0
        self.feedListHasNext = false
    }
}

// MARK: - UseCase Method

extension TrackUseCase {
    
    /// 사각형 좌표에 기반한 TrackMap의 TrackList를 반환합니다.
    func fetchMapTrackLst(rectLocation: RectLocation) async {
        let result = await trackService.fetchTrackList(rectLocation: rectLocation)
        switch result {
        case .success(let trackList): self.mapTrackList = trackList
        case .failure(let error): print(error) // TODO: 에러 처리
        }
    }
    
    /// TrackFeed의 TrackList를 반환합니다.
    func fetchFeedTrackList() async -> [Track] {
        let result = await trackService.fetchTrackList(page: feedListPage)
        switch result {
        case .success(let trackList):
            self.feedTrackList += trackList.list
            self.feedListPage += 1
            self.feedListHasNext = trackList.hasNext
            return trackList.list
        case .failure(let error):
            print(error) // TODO: 에러 처리
            return []
        }
    }
    
    /// TrackFeed를 페이지네이션 합니다.
    func paginationFeedTrackList() async -> [Track] {
        guard feedListHasNext else { return [] }
        return await fetchFeedTrackList()
    }
    
    /// Feed를 초기화합니다.
    func resetFeed() {
        feedTrackList.removeAll()
        feedListPage = 0
        feedListHasNext = false
    }
    
    /// CurrentTrack을 업데이트합니다.
    func updateCurrentTrack(to track: Track) {
        currentTrack = track
    }
    
    /// CurrentTrack의 음악 정보를 업데이트합니다.
    func updateCurrentTrackMusicInfo(from music: Music) {
        currentTrack.music = music
    }
    
    /// TrackMap의 음악 정보를 업데이트합니다.
    func updateMapTrackListMusicInfo(from musicList: [Music]) {
        var copyMapTrackList = mapTrackList
        for (index, track) in copyMapTrackList.enumerated() {
            if let music = musicList.first(where: { $0.isrc == track.music.isrc }) {
                copyMapTrackList[index].music = music
            }
        }
        
        mapTrackList = copyMapTrackList
    }
    
    /// TrackFeed의 음악 정보를 업데이트합니다.
    func updateFeedTrackListMusicInfo(from musicList: [Music]) {
        var copyFeedTrackList = feedTrackList
        for (index, track) in copyFeedTrackList.enumerated() {
            if let music = musicList.first(where: { $0.isrc == track.music.isrc }) {
                copyFeedTrackList[index].music = music
            }
        }
        
        feedTrackList = copyFeedTrackList
    }
    
    /// 현재 선택된 트랙을 업데이트합니다.
    func fetchCurrentTrack(from trackId: Int) async -> Result<Track, Error> {
        let result = await trackService.fetchCurrent(trackId: trackId)
        switch result {
        case .success(let trackResult):
            currentTrack = trackResult
            return .success(trackResult)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 선택한 트랙의 좋아요를 업데이트합니다.
    func likeTrack(trackId: Int, isLike: Bool) async -> Result<Bool, Error> {
        let result = await trackService.like(trackId: trackId, isLike: !isLike)
        switch result {
        case .success: return .success(!isLike)
        case .failure(let error): return .failure(error)
        }
    }
}

// MARK: - Effect

extension TrackUseCase {
    
    enum Effect {
        case fetchCurrentTrack(id: Int)
        case uploadTrack(isrc: String, image: UIImage?, content: String?, location: Location)
        case reportTrack(trackId: Int)
        case deleteTrack(trackId: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .fetchCurrentTrack(let id):
            Task {
                let result = await trackService.fetchCurrent(trackId: id)
                switch result {
                case .success(let track): self.currentTrack = track
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .uploadTrack(let isrc, let image, let content, let location):
            Task {
                let uploadTrackResult = await trackService.uploadTrack(
                    isrc: isrc,
                    image: image,
                    content: content,
                    location: location
                )
                switch uploadTrackResult {
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
            
        case .deleteTrack(trackId: let trackId):
            Task {
                let result = await trackService.delete(trackId: trackId)
                switch result {
                case .success: break
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
        }
    }
}

// MARK: - TrackAppendSheet Method

extension TrackUseCase {
    
    /// 음악 선택
    func selectTrackAppendMusic(music: Music) {
        self.selectedTrackAppendMusic = music
    }
}
