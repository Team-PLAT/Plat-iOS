//
//  SpotifyViewModel.swift
//  PLAT
//
//  Created by 조우현 on 8/9/24.
//

import Foundation
import SpotifyiOS

class SpotifyViewModel: NSObject, ObservableObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    @Published var isPlaying: Bool = false
    @Published var trackName: String = "Track Name"
    @Published var artistName: String = "Artist Name"
    @Published var albumCover: UIImage? = nil
    @Published var trackDuration: TimeInterval = 0.0
    
    private var appRemote: SPTAppRemote
    private var configuration: SPTConfiguration
    private var sessionManager: SPTSessionManager
    
    override init() {
        self.configuration = SPTConfiguration(clientID: SpotifyConstants.spotifyClientId, redirectURL: SpotifyConstants.redirectUri)
        self.configuration.playURI = ""
        self.configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        self.configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        
        self.appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        self.sessionManager = SPTSessionManager(configuration: configuration, delegate: nil)
        
        super.init()
        
        self.appRemote.delegate = self
        self.appRemote.connectionParameters.accessToken = UserDefaults.standard.string(forKey: SpotifyConstants.accessTokenKey)
        self.connect()
    }
    
    func connect() {
        if appRemote.isConnected {
            print("Already connected to Spotify")
            return
        }
        print("Attempting to connect to Spotify")
        if let accessToken = UserDefaults.standard.string(forKey: SpotifyConstants.accessTokenKey) {
            appRemote.connectionParameters.accessToken = accessToken
            appRemote.connect()
        } else {
            let scope: SPTScope = [.appRemoteControl, .userReadCurrentlyPlaying, .userModifyPlaybackState]
            sessionManager.initiateSession(with: scope, options: .clientOnly, campaign: "")
        }
    }
    
    func handleURL(url: URL) {
        print("Handling URL: \(url)")
        let parameters = appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            print("Received authorization code")
            exchangeCodeForToken(code: code)
        } else if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            print("Received access token")
            appRemote.connectionParameters.accessToken = accessToken
            UserDefaults.standard.set(accessToken, forKey: SpotifyConstants.accessTokenKey)
            appRemote.connect()
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("Authorization error: \(errorDescription)")
        } else {
            print("No authorization code, access token, or error received")
        }
    }
    
    func fetchPlayerState() {
        print("Fetching player state")
        appRemote.playerAPI?.getPlayerState { [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state: \(error.localizedDescription)")
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        }
    }
    
    private func update(playerState: SPTAppRemotePlayerState) {
        print("Updating player state")
        DispatchQueue.main.async {
            self.trackName = playerState.track.name
            self.artistName = playerState.track.artist.name
            self.trackDuration = TimeInterval(playerState.track.duration)
            self.isPlaying = !playerState.isPaused
            self.fetchArtwork(for: playerState.track)
        }
    }
    
    private func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize(width: 300, height: 300)) { [weak self] (image, error) in
            if let image = image as? UIImage {
                self?.albumCover = image
            }
        }
    }
    
    // MARK: - SPTAppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Connected to Spotify")
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state: \(error.localizedDescription)")
            }
        })
        DispatchQueue.main.async {
            self.fetchPlayerState()
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            appRemote.playerAPI?.pause { [weak self] _, error in
                if let error = error {
                    print("Error pausing: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self?.isPlaying = false
                    }
                }
            }
        } else {
            appRemote.playerAPI?.resume { [weak self] _, error in
                if let error = error {
                    print("Error resuming: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self?.isPlaying = true
                    }
                }
            }
        }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Disconnected with error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Failed to connect with error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    // MARK: - SPTAppRemotePlayerStateDelegate
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
}

extension SpotifyViewModel: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Session initiated: \(session)")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Session initiation failed: \(error.localizedDescription)")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session renewed: \(session)")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
}

func renewToken() {
    guard let refreshToken = UserDefaults.standard.string(forKey: "spotify_refresh_token") else {
        print("No refresh token available")
        return
    }
    
    // 토큰 갱신 요청 로직 구현
}


extension SpotifyViewModel {
    func exchangeCodeForToken(code: String) {
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": SpotifyConstants.redirectUri.absoluteString,
            "client_id": SpotifyConstants.spotifyClientId,
            "client_secret": SpotifyConstants.spotifyClientSecretKey
        ]
        
        var request = URLRequest(url: URL(string: SpotifyConstants.tokenExchangeURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error exchanging code for token: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received when exchanging code for token")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    print("Successfully exchanged code for access token")
                    DispatchQueue.main.async {
                        self.appRemote.connectionParameters.accessToken = accessToken
                        UserDefaults.standard.set(accessToken, forKey: SpotifyConstants.accessTokenKey)
                        self.appRemote.connect()
                    }
                } else {
                    print("Unexpected response format when exchanging code for token")
                }
            } catch {
                print("Error parsing token exchange response: \(error)")
            }
        }.resume()
    }
}
