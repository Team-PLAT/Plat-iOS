//
//  MusicControllerInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

protocol MusicControllerInterface {
    func setup() async -> Bool
    func play(_ music: Music)
    func pause()
    func resume()
    func repeatPlayback()
    func updateMusicPlayer(with duration: Double)
    func currentDuration() -> AnyPublisher<Double, Error>
    func fetchMusic(_ music: Music) async -> (durationInMillis: Int?, url: String?, name: String?, artistName: String?)?
}
