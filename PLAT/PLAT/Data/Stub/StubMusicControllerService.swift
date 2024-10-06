//
//  StubMusicControllerService.swift
//  PLAT
//
//  Created by 김민준 on 10/6/24.
//

import Combine

struct StubMusicControllerService: MusicControllerInterface {
    func setup() async -> Result<Bool, any Error> {
        .success(true)
    }
    
    func play(with isrc: String) {
        //
    }
    
    func playPlaylist(with isrcs: [String]) {
        //
    }
    
    func playRandomPlaylist(with isrcs: [String]) {
        //
    }
    
    func pause() {
        //
    }
    
    func resume() {
        //
    }
    
    func repeatPlayback() {
        //
    }
    
    func updateMusicPlayer(with duration: Double) {
        //
    }
    
    func currentDuration() -> AnyPublisher<Double, any Error> {
        return Empty<Double, Error>().eraseToAnyPublisher()
    }
    
    func fetchMusic(with isrc: String) async -> Result<Music, any Error> {
        .success(MockDataBuilder.music)
    }
    
    func searchMusic(term: String, searchOffset: Int) async -> [Music] {
        []
    }
}
