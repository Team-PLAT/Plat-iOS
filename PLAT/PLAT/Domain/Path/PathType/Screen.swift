//
//  Screen.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import Foundation

enum Screen: Identifiable, Hashable {
    
    // 회원가입 및 로그인
    case onboarding
    case signUpOrIn
    case selectStreamAccount
    
    // 트랙
    case trackMap
    case trackFeed
    
    // 플레이리스트
    case playlist
    case playlistDetail
    case playlistDetailsEditView
    
    // 신고
    case report(trackId: Int64)
    
    // 설정
    case userDetail
    case nicknameSetting
    case accountSetting
    case streamAccountSetting
    case aboutPlatSettings
    
    var id: Self { self }
}
