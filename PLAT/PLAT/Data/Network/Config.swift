//
//  Config.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let appleMusicToken = "APPLE_MUSIC_TOKEN"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist 찾지 못함")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Config.baseURL 오류")
        }
        return key
    }()
    
    static let appleMusicToken: String = {
        guard let token = Config.infoDictionary[Keys.Plist.appleMusicToken] as? String else {
            fatalError("Config.appleMusicToken 오류")
        }
        return token
    }()
}
