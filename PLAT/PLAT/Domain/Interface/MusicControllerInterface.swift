//
//  MusicControllerInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

protocol MusicControllerInterface {
    func setup()
    func play(_ music: Music)
    func pause()
    func resume()
    func previous()
    func next()
    func repeatPlayback()
}
