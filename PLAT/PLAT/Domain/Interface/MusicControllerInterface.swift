//
//  MusicControllerInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation
import Combine

protocol MusicControllerInterface {
    func setup(completion: @escaping () -> Void)
    func fetchMusic(_ isrc: String) async -> Music?
    func play(_ isrc: String)
    func pause()
    func resume()
    func currentDuration() -> AnyPublisher<Double, Error>
    func movePosition(to duration: Double)
}
