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
        Task {
            if let currentSongId = await requestSongId(for: music.isrc) {
                let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [currentSongId])
                musicPlayer.setQueue(with: descriptor)
                musicPlayer.play()
            } else {
                print("requestSongId 실패")
            }
        }
    }
    
    /// 음악 일시정지
    func pause() {
        musicPlayer.pause()
    }
    
    /// 음악 재생
    func resume() {
        musicPlayer.play()
    }
    
    func repeatPlayback() {
        print(#function)
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
}

extension AppleMusicController {
    
    /// 애플 뮤직 권한을 요청합니다.
    func requestAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }
    
    /// ISRC값을 이용해 songId를 반환합습니다.
    private func requestSongId(for isrc: String) async -> String? {
            print("잘 들어오신 isrc", isrc)
            let urlString = "https://api.music.apple.com/v1/catalog/kr/songs?filter[isrc]=\(isrc)"
            
            guard let url = URL(string: urlString) else {
                print("잘못된 URL")
                return nil
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Config.appleMusicToken)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("HTTP 요청 실패: \(response)")
                    return nil
                }
                
                let decoder = JSONDecoder()
                let result = try decoder.decode(MusicCatalogSearchResponse.self, from: data)
                
                firstSong = result.data.first

                return firstSong?.id
                
            } catch {
                print("에러 발생: \(error)")
                return nil
            }
        }
        
    /// 현재 song의 기타 세부정보를 반환합니다.
    func getCurrentSongDetails(for isrc: String) -> (durationInMillis: Int?, url: String?, name: String?, artistName: String?)? {
            guard let song = firstSong else { return nil }
            return (song.attributes.durationInMillis, song.attributes.url, song.attributes.name, song.attributes.artistName)
        }
    }
