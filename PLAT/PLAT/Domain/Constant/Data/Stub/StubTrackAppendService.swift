//
//  StubTrackAppendService.swift
//  PLAT
//
//  Created by 박준우 on 8/19/24.
//

import Foundation
import MusicKit

struct StubTrackAppendService: TrackAppendServiceInterface {
    
    // TODO: 스트리밍 계정에 따라 다른 검색엔진 사용하도록(여기서 처리할지, 아예 함수를 다르게 구성할지...)
    func searchMusic(term: String) async -> [Music] {
        
        var reqeust = MusicCatalogSearchRequest(term: term, types: [Song.self])
        // TODO: 페이징
        reqeust.offset = 0
        // TODO: 한 번에 불러올 개수 설정
        reqeust.limit = 25
        do {
            let result = try await reqeust.response()
            let songs = result.songs
            var musicList: [Music] = []
            musicList = songs.map({ song in
                let musicData = Music(isrc: "", title: "", artist: "", albumImageUrl: "", duration: 0)
                guard let musicIsrc = song.isrc else {
                    // TODO: isrc가 nil일 경우 처리
                    return musicData
                }
                // TODO: artwork 크기 설정
                guard let musicArtworkURL = song.artwork?.url(width: 256, height: 256) else {
                    // TODO: artworkURL가 nil일 경우 처리
                    return musicData
                }
                guard let musicDuration = song.duration else {
                    // TODO: duration이 nil일 경우 처리
                    return musicData
                }
                
                return Music(isrc: musicIsrc, title: song.title, artist: song.artistName, albumImageUrl: musicArtworkURL.absoluteString, duration: musicDuration)
            })
            return musicList
        } catch {
            print(error)
            return []
        }
    }
    
    func postTrack(track: Track) {
        print(#function)
    }
}
