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
    
    var musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    var song: Song? = nil
    
    static let shared = AppleMusicController()
}

// MARK: - Interface Method

extension AppleMusicController {
    
    func setup(_ music: Music) {
        print(#function)
    }
    
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
    
    func pause() {
        print(#function)
    }
    
    func resume() {
        print(#function)
    }
    
    func repeatPlayback() {
        print(#function)
    }
    
    func currentDuration() -> AnyPublisher<Double, Error> {
        print(#function)
        

        let duration: Double = 180.0 // 예를 들어, 3분 0초
        return Just(duration)
            .setFailureType(to: Error.self) // 실패 타입 설정
            .eraseToAnyPublisher() // AnyPublisher로 변환
    }
}

extension AppleMusicController {
    
    ///애플 뮤직 권한 요청
    func requestAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }
    
    /// isrc -> songId로 변환
    private func requestSongId(for isrc: String) async -> String? {
        let isAuthorized = await requestAuthorization()
        guard isAuthorized else {
            print("권한 없음")
            return nil
        }
        
        let urlString = "https://api.music.apple.com/v1/catalog/us/songs?filter[isrc]=\(isrc)"
        
        guard let url = URL(string: urlString) else {
            print("잘못된 URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Config.appleMusicToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP 요청 실패: \(response)")
                return nil
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(MusicCatalogSearchResponse.self, from: data)
            
            return result.data.first?.id
        } catch {
            print("에러 발생: \(error)")
            return nil
        }
        
    }
}


