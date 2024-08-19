//
//  MockDataBuilder.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

struct MockDataBuilder {
    
    /// Mock playlist 데이터를 반환합니다.
    static var playlist: Playlist {
        return Playlist(
            title: "지곡동에서의 PLAT",
            imageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fsoundcloud.com%2Fyellowtael%2Ffixyou&psig=AOvVaw1wNBlsAj8UtkxoKljBUAiY&ust=1723793152795000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCOjqtIa89ocDFQAAAAAdAAAAABAE",
            trackList: Array(repeating: track, count: 6)
        )
    }
    
    /// Mock trackList 데이터를 반환합니다.
    static var trackList: [Track] {
        return zip(Array(repeating: music, count: 6), locationList).map { music, location in
            Track(
                music: music,
                location: location,
                platter: user,
                createdDate: .now
            )
        }
    }
    
    /// Mock feedTrack 데이터를 반환합니다.
    static var feedTrack: [Track] {
        return [
            Track(
                music: music,
                location: currentLocation,
                platter: friend,
                content: "멀보냐능!자고싶다자고싶다 졸려 엥엥엥에에에엥 방학을 주라",
                imageUrl: "",
                createdDate: .now,
                isLike: true,
                isReported: false
            ),
            Track(
                music: music,
                location: currentLocation,
                platter: user,
                content: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세여~",
                imageUrl: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R692.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                music: music,
                location: currentLocation,
                platter: friend,
                content: "",
                imageUrl: "",
                createdDate: .now,
                isLike: false,
                isReported: false
            )
        ]
    }

    /// Mock track 데이터를 반환합니다.
    static var track: Track {
        return Track(
            music: music,
            location: currentLocation,
            platter: user,
            content: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세여~",
            imageUrl: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R692.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic",
            createdDate: .now,
            isLike: false,
            isReported: false
        )
    }
    
    static var musicList: [Music] {
        return [
            Music(
                isrc: "GBAYE0500605",
                title: "Fix you",
                artist: "ColdPlay",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
                duration: 295533
            ),
            
            Music(
                isrc: "KRA382001452",
                title: "Flowering",
                artist: "LUCY",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2735b558b31b6ba531d48f46007",
                duration: 251293
            ),
            
            Music(
                isrc: "GBAYE0500605",
                title: "Fix you",
                artist: "ColdPlay",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
                duration: 295533
            ),
            
            Music(
                isrc: "GBAYE0500605",
                title: "Fix you",
                artist: "ColdPlay",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
                duration: 295533
            ),
            
            Music(
                isrc: "GBAYE0500605",
                title: "Fix you",
                artist: "ColdPlay",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
                duration: 295533
            ),
            
            Music(
                isrc: "GBAYE0500605",
                title: "Fix you",
                artist: "ColdPlay",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
                duration: 295533
            )
        ]
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
    
    /// Mock currentLocation 데이터를 반환합니다.
    static var currentLocation: Location {
        return Location(
            latitude: 36.014077390156416,
            longitude: 129.3258820318646
        )
    }
    
    /// Mock trackLocationList 데이터를 반환합니다.
    static var locationList: [Location] {
        return [
            Location(latitude: 36.01032332879186, longitude: 129.32943400918083),
            Location(latitude: 36.01564775556712, longitude: 129.32295876966293),
            Location(latitude: 36.01867120920973, longitude: 129.32409007297255),
            Location(latitude: 36.01695052119649, longitude: 129.3208232860788),
            Location(latitude: 36.01317359607363, longitude: 129.32137789913355),
            Location(latitude: 36.01269106639098, longitude: 129.32489032489292)
        ]
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
