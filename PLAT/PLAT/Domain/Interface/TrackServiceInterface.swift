//
//  TrackServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

protocol TrackServiceInterface {
    func fetchTrackList(rectLocation: RectLocation) async -> Result<[Track], Error>
    func fetchTrackList(page: Int) async -> Result<[Track], Error>
    func fetchDetail(track: Track) async -> Result<Track, Error>
    func upload(track: Track) async -> Result<Void, Error>
    func like(track: Track) async -> Result<Void, Error>
    func report(track: Track) async -> Result<Void, Error>
}
