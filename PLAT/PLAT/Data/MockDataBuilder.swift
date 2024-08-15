//
//  MockDataBuilder.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

struct MockDataBuilder {
    
    /// Mock trackList 데이터를 반환합니다.
    static var trackList: [Track] {
        return Array(repeating: track, count: 6)
    }
    
    /// Mock track 데이터를 반환합니다.
    static var track: Track {
        return Track(
            music: music,
            location: location,
            platter: user,
            content: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세여~",
            imageUrl: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R692.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic",
            createdDate: .now,
            isLike: false,
            isReported: false
        )
    }
    
    /// Mock Music 데이터를 반환합니다.
    static var music: Music {
        return Music(
            isrc: "GBAYE0500605",
            title: "Fix you",
            artist: "ColdPlay",
            albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
            duration: 365
        )
    }
    
    /// Mock Location 데이터를 반환합니다.
    static var location: Location {
        return Location(
            latitude: 36.014077390156416,
            longitude: 129.3258820318646
        )
    }
    
    /// Mock User 데이터를 반환합니다.
    static var user: User {
        return User(
            nickname: "한톨",
            profileImageUrl: "https://mblogthumb-phinf.pstatic.net/MjAyMjA4MjRfMTgy/MDAxNjYxMzIwNjIzODk5.OWc2z-YXeLFvyvYahPkySEAO2L4HtljLNqmL1y1D5l0g.jE14uKWjrHUYRNX7VfU95-PxStNktetch_hngxM3Q-Eg.JPEG.ages9090/KakaoTalk_20220824_140238973_17.jpg?type=w800",
            streamAccount: .spotify
        )
    }
    
    /// Mock Friend 데이터를 반환합니다.
    static var friend: Friend {
        return Friend(
            nickname: "페더",
            profileImageUrl: "https://p.turbosquid.com/ts-thumb/YS/jomAmS/ulZxDbeh/render01/jpg/1282179377/600x600/fit_q87/edab67ff7df50901ab9f109305d5a692b68477a7/render01.jpg"
        )
    }
}
