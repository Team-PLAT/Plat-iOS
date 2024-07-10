//
//  Tab.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import Foundation

enum Tab: Identifiable, CaseIterable {
    case map
    case feed
    case playlist
    case account
    
    /// ID를 생성합니다.
    var id: UUID {
        return .init()
    }
    
    /// 탭바의 타이틀을 반환합니다.
    var title: String {
        switch self {
        case .map: return "지도"
        case .feed: return "피드"
        case .playlist: return "플레이리스트"
        case .account: return "내 계정"
        }
    }
    
    /// 탭바의 아이콘을 반환합니다.
    var icon: String {
        switch self {
        case .map: return "map"
        case .feed: return "square.on.square"
        case .playlist:  return "music.note.list"
        case .account: return "person.crop.circle"
        }
    }
}
