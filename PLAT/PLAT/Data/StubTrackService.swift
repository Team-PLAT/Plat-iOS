//
//  StubTrackService.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

struct StubTrackService: TrackServiceInterface {
    func fetchTrack(with trackId: Int) async -> Track? {
        return MockDataBuilder.feedTrack.randomElement()
    }
    
    func like(trackId: String) {
        print(#function)
    }
    
    func delete(trackId: String) {
        print(#function)
    }
    
    func report(trackId: String) {
        print(#function)
    }
    
    func addToPlaylist(trackId: String, playlistId: String) {
        print(#function)
    }
}
