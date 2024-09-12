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
            trackList: trackList
        )
    }
    
    /// Mock trackList 데이터를 반환합니다.
    static var trackList: [Track] {
        return [
            Track(
                id: 000001,
                music: musicList[0],
                location: locationList[0],
                platter: user,
                content: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세여~",
                imageUrl: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R692.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000002,
                music: musicList[1],
                location: locationList[1],
                platter: friend,
                content: "회고(回顧)는 단순히 과거를 되돌아보는 것을 넘어, 우리의 경험과 성장을 되새기며 미래를 위한 지혜를 얻는 과정입니다. 회고는 삶의 여정 속에서 순간순간의 의미와 가치를 발견하고, 성공과 실패를 통해 얻은 교훈을 재정리하며, 이를 바탕으로 더 나은 미래를 설계하는 지적이고 감성적인 작업입니다.",
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000003,
                music: musicList[2],
                location: locationList[2],
                platter: friend,
                content: "회고(回顧)는 단순히 과거를 되돌아보는 것을 넘어, 우리의 경험과 성장을 되새기며 미래를 위한 지혜를 얻는 과정입니다. 회고는 삶의 여정 속에서 순간순간의 의미와 가치를 발견하고, 성공과 실패를 통해 얻은 교훈을 재정리하며, 이를 바탕으로 더 나은 미래를 설계하는 지적이고 감성적인 작업입니다.",
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000004,
                music: musicList[3],
                location: locationList[3],
                platter: friend,
                content: nil,
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000005,
                music: musicList[4],
                location: locationList[4],
                platter: friend,
                content: nil,
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000006,
                music: musicList[5],
                location: locationList[5],
                platter: friend,
                content: nil,
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            )
        ]
    }
    
    /// Mock feedTrack 데이터를 반환합니다.
    static var feedTrack: [Track] {
        return [
            Track(
                id: 000001,
                music: musicList[0],
                location: currentLocation,
                platter: friend,
                content: "멀보냐능!",
                imageUrl: "",
                createdDate: .now,
                isLike: true,
                isReported: false
            ),
            Track(
                id: 000002,
                music: musicList[1],
                location: currentLocation,
                platter: user,
                content: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세여~",
                imageUrl: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R692.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic",
                createdDate: .now,
                isLike: false,
                isReported: false
            ),
            Track(
                id: 000003,
                music: musicList[2],
                location: currentLocation,
                platter: friend,
                content: "회고(回顧)는 단순히 과거를 되돌아보는 것을 넘어, 우리의 경험과 성장을 되새기며 미래를 위한 지혜를 얻는 과정입니다. 회고는 삶의 여정 속에서 순간순간의 의미와 가치를 발견하고, 성공과 실패를 통해 얻은 교훈을 재정리하며, 이를 바탕으로 더 나은 미래를 설계하는 지적이고 감성적인 작업입니다.",
                imageUrl: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1",
                createdDate: .now,
                isLike: false,
                isReported: false
            )
        ]
    }

    /// Mock track 데이터를 반환합니다.
    static var track: Track {
        return Track(
            id: 00000001,
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
                isrc: "KRMIM2210467",
                title: "Abnormal Climate",
                artist: "GIRIBOY",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2738d4a02d1e213c917001f0074",
                duration: 246426
            ),
            
            Music(
                isrc: "KRA492101385",
                title: "Calibrate",
                artist: "Ha Hyun Sang",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b273b48ee14df764cf20d4daed5b",
                duration: 225813
            ),
            
            Music(
                isrc: "KRA381701433",
                title: "Like it",
                artist: "Yoon Jong Shin",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b27334fdd01f17d87acc8b8c925a",
                duration: 328362
            ),
            
            Music(
                isrc: "JPR652100061",
                title: "odoriko",
                artist: "Vaundy",
                albumImageUrl: "https://i.scdn.co/image/ab67616d0000b27364c8b41faf576a0bab551fb9",
                duration: 230109
            )
        ]
    }
    
    /// Mock Music 데이터를 반환합니다.
    static var music: Music {
        return Music(
            isrc: "KRA382001452",
            title: "Fix you",
            artist: "ColdPlay",
            albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651",
            duration: 295.533
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
            Location(latitude: 36.00664365245796, longitude: 129.32451306735135)
        ]
    }
    
    /// Mock User 데이터를 반환합니다.
    static var user: User {
        return User(
            nickname: "한톨",
            profileImageUrl: "https://mblogthumb-phinf.pstatic.net/MjAyMjA4MjRfMTgy/MDAxNjYxMzIwNjIzODk5.OWc2z-YXeLFvyvYahPkySEAO2L4HtljLNqmL1y1D5l0g.jE14uKWjrHUYRNX7VfU95-PxStNktetch_hngxM3Q-Eg.JPEG.ages9090/KakaoTalk_20220824_140238973_17.jpg?type=w800",
            streamAccount: .appleMusic
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
