//
//  StubMusicController.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

struct StubMusicController: MusicControllerInterface {
    func setup(completion: @escaping () -> Void) {
        print(#function)
    }
    
    func fetchMusic(_ isrc: String) async -> Music? {
        return MockDataBuilder.music
    }
    
    func play(_ isrc: String) {
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
    
    func repeatPlayback() {
        print(#function)
    }
    
    func currentDuration() -> AnyPublisher<Double, Error> {
        return Empty<Double, Error>().eraseToAnyPublisher()
    }
}
