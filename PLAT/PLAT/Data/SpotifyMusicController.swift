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
    
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    /// Spotify 개발자 웹사이트에서 앱에 제공되는 자격 증명을 보유하는 구성 클래스입니다.
    private lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: URL(string: spotifyRedirectURL)!
    )
    
    /// SPTAppRemote는 iOS용 Spotify App Remote를 사용하여
    /// Spotify 앱과 상호 작용하기 위한 주요 진입점입니다.
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    // 이 코드는 앱이 활성화되거나 백그라운드에서 종료되는 것을 수신합니다.
    // 이에 따라 Spotify의 API에 자동으로 연결하거나 연결을 끊으므로
    // 앱이 Spotify와의 연결 상태를 효율적으로 관리할 수 있습니다.
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
    func setup() {
        if !appRemote.isConnected {
            authorize()
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
            return nil
        }
    }
}

// MARK: - Authorization

extension SpotifyMusicController {
    
    /// 사용자가 Spotify에 로그인하고 앱을 승인하면
    /// Spotify는 액세스 토큰이 포함된 URL을 사용하여
    /// 사용자를 앱으로 다시 리디렉션합니다.
    /// 이 함수는 URL에서 토큰을 추출하여 향후 API 요청을 위해 저장합니다.
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            print("AccessToken: \(accessToken)")
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    /// 이는 연결을 시작하기 위해 버튼에 의해 호출되는 메서드입니다.
    /// appRemote 객체에서 AuthorizeAndPlayURI를 호출합니다.
    /// AuthorizeAndPlayURI는 특정 Spotify URI의 재생을 시작할 수 있지만
    /// 여기에서처럼 빈 문자열("")을 전달하면 재생을 시작하지 않고 승인 프로세스만 트리거됩니다.
    func authorize() {
        self.appRemote.authorizeAndPlayURI("")
    }
}

// MARK: - Connection

extension SpotifyMusicController {
    
    /// Spotify 애플리케이션에 연결을 시도합니다.
    /// 앱 상태 변경에 응답하여 호출되어 앱이 사용 중일 때
    /// 안정적인 연결을 유지합니다.
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
