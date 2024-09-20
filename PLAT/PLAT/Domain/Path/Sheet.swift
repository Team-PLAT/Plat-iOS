//
//  Sheet.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import Foundation

enum Sheet: Identifiable, Hashable {
    
    // 회원가입 및 로그인
    case whyConnectStreamAccount
    
    // 트랙
    case trackAppendToPlaylist
    case trackAppendSearch
    
    // 플레이리스트
    case playlistDetail
    case playlistInfo
    case appendPlaylist
    
    var id: Self { self }
}
