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
    
    func fetchDetail(track: Track) async -> Result<Track, any Error> {
        return .success(MockDataBuilder.track)
    }
    
    func upload(track: Track) async -> Result<Void, any Error> {
        return .success(Void())
    }
    
    func like(track: Track) async -> Result<Void, any Error> {
        return .success(Void())
    }
    
    func report(track: Track) async -> Result<Void, any Error> {
        return .success(Void())
    }
}
