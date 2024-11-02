//
//  TrackServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import UIKit

protocol TrackServiceInterface {
    func fetchTrackList(rectLocation: RectLocation) async -> Result<[Track], Error>
    func fetchTrackList(page: Int) async -> Result<TrackList, Error>
    func fetchCurrent(trackId: Int) async -> Result<Track, Error>
    func uploadTrack(isrc: String, image: UIImage?, content: String?, location: Location) async -> Result<Void, Error>
    func like(trackId: Int, isLike: Bool) async -> Result<Void, Error>
    func report(trackId: Int) async -> Result<Void, Error>
    func delete(trackId: Int) async -> Result<Void, Error>
}
