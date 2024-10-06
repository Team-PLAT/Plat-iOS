//
//  AppleMusicControllerServiceImpl.swift
//  PLAT
//
//  Created by 조세연 on 8/21/24.
//

import Foundation
import Combine
import MusicKit
import MediaPlayer

// MARK: - AppleMusicController

final class AppleMusicControllerServiceImpl: NSObject, MusicControllerInterface {

    enum AppleMusicError: Error {
        case invalidAuthorization
        case fetchFailed
    }
    
    private var firstSong: ResponseSong?
    private var musicPlayer = MPMusicPlayerController.applicationQueuePlayer
}

// MARK: - Interface Method

extension AppleMusicControllerServiceImpl {
    
    /// 권한 요청
    func setup() async -> Result<Bool, Error> {
        let isAuthorized = await requestAuthorization()
        if isAuthorized {
            if await checkMusicSubscription() {
                return .success(true)
            } else {
                return .success(false)
            }
        } else {
            return .failure(AppleMusicError.invalidAuthorization)
        }
    }
    
    /// 음악 첫 재생
    func play(with isrc: String) {
        if let songId = firstSong?.id {
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [songId])
            musicPlayer.setQueue(with: descriptor)
            musicPlayer.play()
        } else {
            print("음악 재생 오류")
        }
    }
    
    /// 플리 재생
    func playPlaylist(with isrcs: [String]) {
        Task {
            let songIDs = await requestSongIds(for: isrcs)
            if !songIDs.isEmpty {
                let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: Array(songIDs))
                musicPlayer.setQueue(with: descriptor)
                musicPlayer.play()
            } else {
                print("플레이리스트에 곡이 없습니다.")
            }
        }
    }
    
    /// 플리 임의 재생
    func playRandomPlaylist(with isrcs: [String]) {
        Task {
            var songIDs = await requestSongIds(for: isrcs)
            songIDs.shuffle()
            if !songIDs.isEmpty {
                let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: songIDs)
                musicPlayer.setQueue(with: descriptor)
                musicPlayer.play()
            } else {
                print("플레이리스트에 곡이 없습니다.")
            }
        }
    }
    
    /// 음악 일시정지
    func pause() {
        musicPlayer.pause()
    }
    
    /// 음악 다시 재생
    func resume() {
        musicPlayer.play()
    }
    
    func repeatPlayback() {
        print(#function)
    }
    
    /// 음악 업데이트
    func updateMusicPlayer(with duration: Double) {
        if musicPlayer.playbackState == .playing {
            musicPlayer.currentPlaybackTime = duration
        } else {
            print("음악이 재생 중이지 않음")
        }
    }
    
    /// 현재 음악 시간
    func currentDuration() -> AnyPublisher<Double, Error> {
        return Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .flatMap { [weak self] _ -> Future<Double, Error> in
                return Future { promise in
                    let playbackPosition = self?.musicPlayer.currentPlaybackTime ?? 0.0
                    promise(.success(playbackPosition))
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Music 정보 받아오는 함수
    func fetchMusic(with isrc: String) async -> Result<Music, Error> {
        await requestSongId(for: isrc)
        
        if let song = firstSong,
           let title = song.attributes.name,
           let artist = song.attributes.artistName,
           let albumImageUrl = song.attributes.artwork?.url,
           let duration = song.attributes.durationInMillis {
            
            let music = Music(
                isrc: isrc,
                title: title,
                artist: artist,
                albumImageUrl: albumImageUrl,
                duration: Double(duration)
            )
            
            return .success(music)
        } else {
            return .failure(AppleMusicError.fetchFailed)
        }
    }
    
    /// 음악 검색
    func searchMusic(term: String, searchOffset: Int) async -> Result<[Music], Error> {
        if !term.isEmpty {
            var reqeust = MusicCatalogSearchRequest(term: term, types: [Song.self])
            reqeust.offset = searchOffset
            reqeust.limit = 25
            do {
                let result = try await reqeust.response()
                let songs = result.songs
                var musicList: [Music] = []
                musicList = songs.map({ song in
                    let musicData = Music(isrc: "", title: "", artist: "", albumImageUrl: "", duration: 0)
                    guard let musicIsrc = song.isrc else {
                        return musicData
                    }
                    guard let musicArtworkURL = song.artwork?.url(width: 256, height: 256) else {
                        return musicData
                    }
                    guard let musicDuration = song.duration else {
                        return musicData
                    }
                    
                    return Music(isrc: musicIsrc, title: song.title, artist: song.artistName, albumImageUrl: musicArtworkURL.absoluteString, duration: musicDuration)
                })
                return .success(musicList)
            } catch {
                print(error)
                return .failure(error)
            }
        } else {
            return .success([])
        }
    }
}

extension AppleMusicControllerServiceImpl {
    
    /// 애플 뮤직 권한을 요청합니다.
    private func requestAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }
    
    /// 구독 여부를 Bool값으로 반환받습니다.
    private func checkMusicSubscription() async -> Bool {
        do {
            let currentSubscription = try await MusicSubscription.current
            if currentSubscription.canPlayCatalogContent {
                return true
            } else {
                return false
            }
        } catch {
            print("구독 상태를 가져오는 중 오류 발생: \(error)")
            return false
        }
    }
    
    /// ISRC값을 이용해 songId를 반환받습니다.
    private func requestSongId(for isrc: String) async {
        
        let urlString = "https://api.music.apple.com/v1/catalog/kr/songs?filter[isrc]=\(isrc)"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.appleMusicToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP 요청 실패: \(response)")
                return
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(MusicCatalogSearchResponse.self, from: data)
            
            if var firstSong = result.data.first {
                if var artwork = firstSong.attributes.artwork {
                    if let originalUrl = artwork.url {
                        let cleanedUrl = originalUrl
                            .replacingOccurrences(of: "/{w}x{h}bb.jpg", with: "/800x800bb.jpg")
                        artwork.url = cleanedUrl
                    }
                    firstSong.attributes.artwork = artwork
                }
                
                self.firstSong = firstSong
            } else {
                print("ISRC: \(isrc) - 첫 번째 노래 정보가 없습니다.")
            }
            
        } catch {
            print("에러 발생: \(error)")
        }
    }
    
    private func requestSongIds(for isrcs: [String]) async -> [String] {
        var songIDs: [String] = []
        
        for isrc in isrcs {
            await requestSongId(for: isrc)
            if let songId = self.firstSong?.id {
                songIDs.append(songId)
            }
        }
        
        return songIDs
    }
}
