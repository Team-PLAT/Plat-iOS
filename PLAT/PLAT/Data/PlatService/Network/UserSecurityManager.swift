//
//  UserSecurityManager.swift
//  PLAT
//
//  Created by 김민준 on 9/16/24.
//

import Foundation

final class UserSecurityManager {
    
    static let shared = UserSecurityManager()
    private init() {}
    
    private(set) var encryptedUserIdentifier = ""
    private(set) var accessToken = ""
    private(set) var refreshToken = ""
    
    /// Encrypted User Identifier을 업데이트합니다.
    func updateEncryptedUserIdentifier(_ value: String) {
        self.encryptedUserIdentifier = value
    }
    
    /// AccessToken을 업데이트합니다.
    func updateAccessToken(_ value: String) {
        self.accessToken = value
    }
    
    /// RefreshToken을 업데이트합니다.
    func updateRefreshToken(_ value: String) {
        self.refreshToken = value
    }
    
    /// 로그아웃 시에 AccessToken을 제거합니다.
    func clearAccessToken() {
        self.accessToken = ""
    }
    
    /// 로그아웃 시에 RefreshToken을 제거합니다.
    func clearRefreshToken() {
        self.refreshToken = ""
    }
}
