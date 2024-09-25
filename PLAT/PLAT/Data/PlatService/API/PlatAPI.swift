//
//  Plat.swift
//  PLAT
//
//  Created by 김민준 on 9/3/24.
//

import Foundation

extension APIs.Plat {
    
    /// Member API
    enum Members: RawRepresentable, API {
        
        static let baseUrl: URL = APIs.Plat.baseURL.appendingPathComponent("members")
        
        case signIn // 로그인
        case uploadProfileAvatar // 유저 프로필 사진 업로드
        case fetchProfileStreamType // 유저 스트리밍 계정 조회
        case updateProfileStreamType // 유저 스트리밍 계정 선택(변경)
        case updateProfileNickname // 유저 프로필 닉네임 변경
        case updateProfileAvatar // 유저 프로필 사진 변경
        case fetchProfile // 유저 프로필 조회
        case resign // 회원 탈퇴
        
        var rawValue: RawValue {
            switch self {
            case .signIn: return "sign-in"
            case .uploadProfileAvatar: return "profile/avatar/upload"
            case .fetchProfileStreamType: return "profile/stream-type"
            case .updateProfileStreamType: return "profile/stream-type"
            case .updateProfileNickname: return "profile/nickname"
            case .updateProfileAvatar: return "profile/avatar"
            case .fetchProfile: return "profile"
            case .resign: return "resign"
            }
        }
    }
    
    /// Track API
    enum Tracks: RawRepresentable, API {
        
        static let baseUrl: URL = APIs.Plat.baseURL.appendingPathComponent("tracks")
        
        case upload
        case report(trackId: Int64)
        case like(trackId: Int64)
        case fetch(trackId: Int64)
        case fetchFeed
        case fetchMap
        
        var rawValue: RawValue {
            switch self {
            case .upload: return ""
            case let .report(trackId): return "\(trackId)/report"
            case let .like(trackId): return "\(trackId)/like"
            case let .fetch(trackId): return "\(trackId)"
            case .fetchFeed: return "feeds"
            case .fetchMap: return "map"
            }
        }
    }
    
    /// PlaylistAPI
    enum Playlists: RawRepresentable, API {
        static let baseUrl: URL = APIs.Plat.baseURL.appendingPathComponent("playlists")
        
        case fetchPlaylists
        case fetchPlaylistDetail(playlistId: Int64)
        case searchPlaylist
        case upload
        case appendTrackToPlaylist(playlistId: Int64)
        case delete(playlistId: Int64)
        
        var rawValue: RawValue {
            switch self {
            case .fetchPlaylists: return ""
            case .fetchPlaylistDetail(let playlistId): return "/\(playlistId)/detail"
            case .searchPlaylist: return "/search"
            case .upload: return ""
            case .appendTrackToPlaylist(let playlistId): return "\(playlistId)"
            case .delete(let playlistId): return "\(playlistId)"
            }
        }
    }
    
    /// Image API
    enum Images: RawRepresentable, API {
        static let baseUrl: URL = APIs.Plat.baseURL.appendingPathComponent("images")
        
        case upload
        
        var rawValue: RawValue {
            switch self {
            case .upload: return ""
            }
        }
    }
    
    /// Address API
    enum Address: RawRepresentable, API {
        static let baseUrl: URL = APIs.Plat.baseURL.appendingPathComponent("address")
        
        case reverseGeocode
        
        var rawValue: RawValue {
            switch self {
            case .reverseGeocode:
                return "reverse-geocode"
            }
        }
    }
}
