//
//  Constants.swift
//  PLAT
//
//  Created by 조우현 on 8/9/24.
//

import Foundation
import SpotifyiOS

struct SpotifyConstants {
    static let accessTokenKey = "access-token-key"
    static let redirectUri = URL(string: "letsplat://")!
    static let spotifyClientId = "70536cf512984395b0ac448002a9f1b6"
    static let spotifyClientSecretKey = "900fa12c16294fda87449375ffef6497"
    static let tokenExchangeURL = "https://accounts.spotify.com/api/token"

    static let scopes: SPTScope = [
        .userReadEmail, .userReadPrivate,
        .userReadPlaybackState, .userModifyPlaybackState, .userReadCurrentlyPlaying,
        .streaming, .appRemoteControl,
        .playlistReadCollaborative, .playlistModifyPublic, .playlistReadPrivate, .playlistModifyPrivate,
        .userLibraryModify, .userLibraryRead,
        .userTopRead, .userReadPlaybackState, .userReadCurrentlyPlaying,
        .userFollowRead, .userFollowModify
    ]

    static let stringScopes = [
        "user-read-email", "user-read-private",
        "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
        "streaming", "app-remote-control",
        "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
        "user-library-modify", "user-library-read",
        "user-top-read", "user-read-playback-position", "user-read-recently-played",
        "user-follow-read", "user-follow-modify"
    ]
}
