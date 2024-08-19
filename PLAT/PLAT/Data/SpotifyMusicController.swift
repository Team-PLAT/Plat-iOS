//
//  SpotifyMusicController.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import Foundation
import Combine
import SpotifyiOS

// MARK: - SpotifyMusicController

final class SpotifyMusicController: NSObject, MusicControllerInterface {
    
    static let shared = SpotifyMusicController()
    
    private let spotifyClientID = "5b202600356943f9bf865d44b7a61bb5"
    private let spotifyRedirectURL = "spotify-ios-quick-start://spotify-login-callback"
    
    private var accessToken: String?
    
    private var subscriptCompletion: (() -> Void)?
    
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    private lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: URL(string: spotifyRedirectURL)!
    )
    
    private lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    private override init() {
        super.init()
        
        connectCancellable = NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.disconnect()
            }
    }
}

// MARK: - Interface Method

extension SpotifyMusicController {
    
    /// 기본 설정을 진행합니다.
    func setup(_ music: Music) {
        if !appRemote.isConnected {
            authorize()
            subscriptCompletion = { [weak self] in
                self?.play(music)
            }
        }
    }
    
    /// 음악을 재생합니다.
    func play(_ music: Music) {
        Task {
            let uri = await requestURI(for: music.isrc)
            appRemote.playerAPI?.play(uri ?? "")
        }
    }
    
    /// 음악을 일시 정지합니다.
    func pause() {
        appRemote.playerAPI?.pause()
    }
    
    /// 음악을 재개합니다.
    func resume() {
        appRemote.playerAPI?.resume()
    }
    
    func previous() {
        //
    }
    
    func next() {
        //
    }
    
    func repeatPlayback() {
        //
    }
    
    func currentDuration() -> AnyPublisher<Double, Error> {
        return Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .flatMap { [weak self] _ -> Future<Double, Error> in
                return Future { promise in
                    self?.appRemote.playerAPI?.getPlayerState { result, error in
                        if let error = error {
                            Log.fail(
                                title: "현재 재생 중인 음악 position 값 불러오기",
                                message: "PlayerState 검색 실패: \(error.localizedDescription)"
                            )
                            promise(.failure(error))
                        } else if let playerState = result as? SPTAppRemotePlayerState {
                            let playbackPostion = Double(playerState.playbackPosition)
                            promise(.success(playbackPostion / 1000))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Helper

extension SpotifyMusicController {
    
    /// Sptotify Web API 호출을 위한 기본 URL입니다.
    private var baseURL: String {
        "https://api.spotify.com/v1/"
    }
    
    /// ISRC값을 이용해 URL 문자열을 반환받습니다.
    private func searchQueryURL(isrc: String) -> String {
        let header = baseURL + "search?"
        let searchQuery = "q=" + "isrc:\(isrc)&"
        let type = "type=" + "track&"
        let market = "market=" + "KR&"
        let limit = "limit=" + "1&"
        return header + searchQuery + type + market + limit
    }
    
    /// ISRC값을 이용해 URI 값을 반환받습니다.
    private func requestURI(for isrc: String) async -> String? {
        let urlString = searchQueryURL(isrc: isrc)
        guard let url = URL(string: urlString) else {
            Log.fail(
                title: "ISRC 값을 이용한 URI 반환",
                message: "조건에 맞지 않는 URL: \(urlString)"
            )
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(accessToken ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("데이터!: \(data)\n")
            
            do {
                let decoder = JSONDecoder()
                let decodeData = try decoder.decode(SpotifyTrackDTO.self, from: data)
                
                guard let uri = decodeData.tracks.items.first?.uri else {
                    Log.fail(
                        title: "ISRC 값을 이용한 URI 반환",
                        message: "값 없음!"
                    )
                    return nil
                }
                
                Log.success(
                    title: "ISRC 값을 이용한 URI 반환",
                    message: "URI: \(uri)"
                )
                
                return uri
                
            } catch {
                Log.fail(
                    title: "ISRC 값을 이용한 URI 반환",
                    message: "Decoding 실패"
                )
            }
            
            return nil
            
        } catch {
            Log.fail(
                title: "ISRC 값을 이용한 URI 반환",
                message: "URLSession 실패: \(error.localizedDescription)"
            )
            
            return nil
        }
    }
}

// MARK: - Authorization

extension SpotifyMusicController {
    
    /// 리디렉션 URL을 통해 AccessToken을 설정합니다.
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            Log.success(title: "Access Token", message: accessToken)
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            Log.fail(title: "Access Token", message: errorDescription)
        }
    }
    
    /// Spotify 인증을 요청합니다.
    private func authorize() {
        self.appRemote.authorizeAndPlayURI("")
    }
}

// MARK: - Connection

extension SpotifyMusicController {
    
    /// Spotify 애플리케이션에 연결을 시도합니다.
    private func connect() {
        if let _ = self.appRemote.connectionParameters.accessToken {
            appRemote.connect()
        }
    }
    
    /// Spotify 애플리케이션 연결을 끊습니다.
    private func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
}

// MARK: - SPTAppRemoteDelegate

extension SpotifyMusicController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe { _, error in
            if let error = error {
                Log.fail(
                    title: "Spotify Player State",
                    message: error.localizedDescription
                )
            } else {
                Log.success(
                    title: "Spotify Player State",
                    message: "구독 성공"
                )
                
                self.subscriptCompletion?()
            }
        }
    }
    
    func appRemote(
        _ appRemote: SPTAppRemote,
        didFailConnectionAttemptWithError error: (any Error)?
    ) {
        // print(#function)
    }
    
    func appRemote(
        _ appRemote: SPTAppRemote,
        didDisconnectWithError error: (any Error)?
    ) {
        // print(#function)
    }
}

// MARK: - SPTAppRemotePlayerStateDelegate

extension SpotifyMusicController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: any SPTAppRemotePlayerState) {
        // print(#function)
    }
}
