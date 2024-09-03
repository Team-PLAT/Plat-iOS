//
//  API.swift
//  PLAT
//
//  Created by 김민준 on 9/3/24.
//

import Foundation

/// API를 추상화하는 프로토콜
protocol API {
    static var baseUrl: URL { get }
}

/// API 열거형
enum APIs {
    enum Plat {
        static let baseURL = URL(string: Config.baseURL)!
    }
}

struct TestAPI {
    
    func test() {
        let members = [
            APIs.Plat.Members.signIn.url,
            APIs.Plat.Members.resign.url,
            APIs.Plat.Members.uploadProfileAvatar.url,
            APIs.Plat.Members.updateProfileAvatar.url,
            APIs.Plat.Members.fetchProfileStreamType.url,
            APIs.Plat.Members.updateProfileStreamType.url,
            APIs.Plat.Members.fetchProfile.url,
            APIs.Plat.Members.updateProfileNickname.url
        ]
        
        print("[Member API]\n")
        members.forEach {
            print("\($0)\n")
        }
        
        let tracks = [
            APIs.Plat.Tracks.upload.url,
            APIs.Plat.Tracks.report(trackId: 0).url,
            APIs.Plat.Tracks.like(trackId: 1).url,
            APIs.Plat.Tracks.fetch(trackId: 2).url,
            APIs.Plat.Tracks.fetchFeed.url,
            APIs.Plat.Tracks.fetchMap.url
        ]
        
        print("[Track API]\n")
        tracks.forEach {
            print("\($0)\n")
        }
    }
}
