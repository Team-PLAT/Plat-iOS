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

class SpotifyMusicController: NSObject, MusicControllerInterface {
    
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
    
    /// 이 코드는 앱이 활성화되거나 백그라운드에서 종료되는 것을 수신합니다.
    /// 이에 따라 Spotify의 API에 자동으로 연결하거나 연결을 끊으므로
    /// 앱이 Spotify와의 연결 상태를 효율적으로 관리할 수 있습니다.
    override init() {
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
    
    func setup() {
        if !appRemote.isConnected {
            authorize()
        }
    }
    
    func play() {
        //
    }
    
    func pause() {
        //
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
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (_, error) in
            if let error = error {
                print("Error subscribing to player state: \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to player state")
            }
        })
    }
    
    func appRemote(
        _ appRemote: SPTAppRemote,
        didFailConnectionAttemptWithError error: (any Error)?
    ) {
        print(#function)
    }
    
    func appRemote(
        _ appRemote: SPTAppRemote,
        didDisconnectWithError error: (any Error)?
    ) {
        print(#function)
    }
}

// MARK: - SPTAppRemotePlayerStateDelegate

extension SpotifyMusicController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: any SPTAppRemotePlayerState) {
        print(#function)
    }
}
