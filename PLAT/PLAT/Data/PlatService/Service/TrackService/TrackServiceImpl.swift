//
//  TrackServiceImpl.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

final class TrackServiceImpl: TrackServiceInterface {
    
    private let imageService: ImageServiceInterface
    private let trackRepository = TrackRepository()
    
    init(imageService: ImageServiceInterface) {
        self.imageService = imageService
    }
    
    /// 현재 위치의 사각형을 기준으로 TrackList를 반환합니다.
    func fetchTrackList(rectLocation: RectLocation) async -> Result<[Track], Error> {
        let request = FetchTrackMapRequest(
            startLatitude: rectLocation.startLatitude,
            startLongitude: rectLocation.startLongitude,
            endLatitude: rectLocation.endLatitude,
            endLongitude: rectLocation.endLongitude
        )
        
        let result = await trackRepository.fetchTrackMap(request: request)
        switch result {
        case .success(let fetchTrackMapResponse):
            let trackList = fetchTrackMapResponse
            return .success(trackList.toTrackList())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 지정된 페이지의 TrackList를 반환합니다.
    func fetchTrackList(page: Int) async -> Result<[Track], Error> {
        let request = FetchTrackFeedRequest(page: Int32(page), size: 20)
        let result = await trackRepository.fetchTrackFeedList(request: request)
        switch result {
        case .success(let fetchTrackFeedResponse):
            let trackList = fetchTrackFeedResponse
            return .success(trackList.toTrackList())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Track 정보를 패치합니다.
    func fetchCurrent(trackId: Int) async -> Result<Track, Error> {
        let request = FetchTrackDetailResquest(trackId: Int64(trackId))
        let result = await trackRepository.fetchTrackDetail(request: request)
        switch result {
        case .success(let fetchTrackDetailResponse):
            let track = fetchTrackDetailResponse.toTrack()
            return .success(track)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 트랙을 게시합니다.
    func uploadTrack(isrc: String, imageData: Data?, content: String?, location: Location) async -> Result<Void, Error> {
        
        var imageUrl = ""
        
        if let imageData = imageData {
            let imageResult = await imageService.uploadImage(imageData: imageData)
            switch imageResult {
            case .success(let platImage): imageUrl = platImage.imageUrl
            case .failure(let imageError): return .failure(imageError)
            }
        }
        
        let result = await trackRepository.uploadTrack(
            request: .init(
                isrc: isrc,
                imageUrl: imageUrl,
                content: content ?? "",
                latitude: location.latitude,
                longitude: location.longitude
            )
        )
        
        switch result {
        case .success: return .success(Void())
        case .failure(let uploadError): return .failure(uploadError)
        }
    }
    
    /// 트랙에 좋아요를 표시합니다.
    func like(trackId: Int, isLike: Bool) async -> Result<Void, Error> {
        let request = LikeTrackRequest(trackId: Int64(trackId), isLiked: isLike)
        let result = await trackRepository.likeTrack(request: request)
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 트랙을 신고합니다.
    func report(trackId: Int) async -> Result<Void, Error> {
        let request = ReportTrackRequset(trackId: Int64(trackId))
        let result = await trackRepository.reportTrack(request: request)
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 트랙을 삭제합니다.
    func delete(trackId: Int) async -> Result<Void, any Error> {
        let result = await trackRepository.deleteTrack(trackId: Int64(trackId))
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
}
