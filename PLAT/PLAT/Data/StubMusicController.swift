//
//  StubMusicController.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

struct StubMusicController: MusicControllerInterface {
    
    func setup() {
        print(#function)
    }
    
    func play(_ music: Music) {
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
    
    func currentDuration() -> AnyPublisher<Double, Never> {
        return Just(0).eraseToAnyPublisher()
    }
}
