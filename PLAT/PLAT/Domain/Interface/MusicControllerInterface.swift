//
//  MusicControllerInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

protocol MusicControllerInterface {
    func setup() async -> Result<Bool, Error>
    func play(_ music: Music)
    func playPlaylist(with isrcs: [String])
    func playRandomPlaylist(with isrcs: [String])
    func pause()
    func resume()
    func repeatPlayback()
    func updateMusicPlayer(with duration: Double)
    func currentDuration() -> AnyPublisher<Double, Error>
    func fetchMusic(with isrc: String) async -> (durationInMillis: Int?, url: String?, name: String?, artistName: String?)?
    func searchMusic(term: String, searchOffset: Int) async -> [Music]
}
