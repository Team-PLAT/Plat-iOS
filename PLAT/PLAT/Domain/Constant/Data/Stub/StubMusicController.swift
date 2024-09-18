//
//  StubMusicController.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

struct StubMusicController: MusicControllerInterface {
    
    func setup() async -> Bool {
        return false
    }
    
    func play(_ music: Music) {
        print(#function)
    }
    
    func playPlaylist(with isrcs: [String]) {
        print(#function)
    }
    
    func playRandomPlaylist(with isrcs: [String]) {
        print(#function)
    }
    
    func pause() {
        print(#function)
    }
    
    func resume() {
        print(#function)
    }
    
    func previous() {
        print(#function)
    }
    
    func next() {
        print(#function)
    }
    
    func updateMusicPlayer(with duration: Double) {
        print(#function)
    }
    
    func repeatPlayback() {
        print(#function)
    }
    
    func currentDuration() -> AnyPublisher<Double, Error> {
        return Empty<Double, Error>().eraseToAnyPublisher()
    }
    
    func fetchMusic(_ music: Music) async -> (durationInMillis: Int?, url: String?, name: String?, artistName: String?)? {
        return (durationInMillis: nil, url: nil, name: nil, artistName: nil)
    }
    
}
