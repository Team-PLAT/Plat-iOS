//
//  TrackAppendServiceInterface.swift
//  PLAT
//
//  Created by 박준우 on 8/19/24.
//

import Foundation

protocol TrackAppendServiceInterface {
    func searchMusic(term: String) async -> [Music]
    func postTrack(music: Music, context: String, location: Location) async
}
