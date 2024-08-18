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
    
    /// Mock track 데이터를 반환합니다.
    static var track: Track {
        return Track(
            music: music,
            location: currentLocation,
            platter: user,
            createdDate: .now
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
            Location(latitude: 36.014077390156416, longitude: 129.3258820318646),
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
            profileImageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fm.blog.naver.com%2Fages9090%2F222856980599&psig=AOvVaw3p8QOpKdbZO6qL92s4cBPN&ust=1723793186854000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCLie-ZW89ocDFQAAAAAdAAAAABAE",
            streamAccount: .spotify
        )
    }
    
    /// Mock Friend 데이터를 반환합니다.
    static var friend: Friend {
        return Friend(
            nickname: "페더",
            profileImageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fko%2Fphotos%2Fai-%25EC%2583%259D%25EC%2584%25B1-%25EA%25B9%2583%25ED%2584%25B8-%25EA%25B5%25AC%25EB%25A6%2584-%25ED%2592%258D%25EA%25B2%25BD-7935605%2F&psig=AOvVaw3CQgwz72rTrjDpO_zr39w3&ust=1723793213672000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCKD9sqO89ocDFQAAAAAdAAAAABAQ"
        )
    }
}
