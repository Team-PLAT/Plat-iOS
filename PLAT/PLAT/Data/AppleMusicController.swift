//
//  AppleMusicController.swift
//  PLAT
//
//  Created by 조세연 on 8/21/24.
//

import Foundation
import Combine
import MusicKit
import MediaPlayer

// MARK: - AppleMusicController

final class AppleMusicController: NSObject, MusicControllerInterface {
    
    private var firstSong: ResponseSong?
    
    var musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    static let shared = AppleMusicController()
}

// MARK: - Interface Method

extension AppleMusicController {
    
    /// 권한 요청
    func setup(_ music: Music) {
        Task {
            let isAuthorized = await requestAuthorization()
            guard isAuthorized else {
                print("권한 없음")
                return
            }
            self.play(music)
        }
    }
    
    /// 음악 첫 재생
    func play(_ music: Music) {
        if let songId = firstSong?.id {
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [songId])
            musicPlayer.setQueue(with: descriptor)
            musicPlayer.play()
        } else {
            print("음악 재생 오류")
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
                if duration >= 0 {
                    musicPlayer.currentPlaybackTime = duration
                    print("🎀🎀🎀🎀", duration)
                } else {
                    print("유효하지 않은 duration 값")
                }
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
    func fetchMusic(_ music: Music) async -> (durationInMillis: Int?, url: String?, name: String?, artistName: String?)? {
        await requestSongId(for: music.isrc)
        
        if let song = firstSong {
            return (song.attributes.durationInMillis, song.attributes.artwork?.url, song.attributes.name, song.attributes.artistName)
        } else {
            print("첫 번째 노래 정보가 없습니다.")
            return nil
        }
    }
}

extension AppleMusicController {
    
    /// 애플 뮤직 권한을 요청합니다.
    private func requestAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }
    
    /// ISRC값을 이용해 songId를 반환합습니다
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
                
                print("URL: \(firstSong.attributes.artwork?.url ?? "없음")")
                
            } else {
                print("첫 번째 노래 정보가 없습니다.")
            }
            
        } catch {
            print("에러 발생: \(error)")
        }
    }
}
