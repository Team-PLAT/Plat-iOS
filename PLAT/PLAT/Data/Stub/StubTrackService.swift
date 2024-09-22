//
//  StubTrackService.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

struct StubTrackService: TrackServiceInterface {
    func fetchTrackList(rectLocation: RectLocation) async -> Result<[Track], any Error> {
        .success(MockDataBuilder.trackList)
    }
    
    func fetchTrackList(page: Int) async -> Result<[Track], any Error> {
        return .success(MockDataBuilder.trackList)
    }
    
    func fetchCurrent(trackId: Int) async -> Result<Track, any Error> {
        return .success(MockDataBuilder.track)
    }
    
    func uploadTrack(isrc: String, imageData: Data?, content: String?, location: Location) async -> Result<Void, Error> {
        return .success(Void())
    }
    
    func like(trackId: Int, isLike: Bool) async -> Result<Void, Error> {
        return .success(Void())
    }
    
    func report(trackId: Int) async -> Result<Void, any Error> {
        return .success(Void())
    }
}
