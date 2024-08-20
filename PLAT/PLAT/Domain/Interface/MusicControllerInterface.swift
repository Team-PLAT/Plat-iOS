//
//  MusicControllerInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

protocol MusicControllerInterface {
    func setup()
    func play(_ music: Music)
    func pause()
    func resume()
    func repeatPlayback()
    func currentDuration() -> AnyPublisher<Double, Error>
}
