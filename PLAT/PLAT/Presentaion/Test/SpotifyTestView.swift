//
//  SpotifyTestView.swift
//  PLAT
//
//  Created by 김민준 on 7/22/24.
//

import SwiftUI

struct StreamMusic {
    let tile: String
    let artist: String
    let trackImage: String
    let duration: Int
}

struct SpotifyTestView: View {
    
    @StateObject private var spotifyController = SpotifyController()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("현재 인증 상태: \(spotifyController.appRemote.isConnected)")
            
            Button("Spotify 인증하기") {
                if !spotifyController.appRemote.isConnected {
                    spotifyController.authorize()
                }
            }.tint(.blue)
            
            SpotifyView()
        }
        .environmentObject(spotifyController)
        .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
        }
    }
}

struct SpotifyView: View {
    
    @EnvironmentObject private var spotifyController: SpotifyController
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: spotifyController.currentTrackImage ?? .init())
                .frame(width: 360, height: 360)
                .aspectRatio(contentMode: .fill)
                .background(.red)
            
            Text(spotifyController.currentTrackName ?? "음원 제목")
                .font(.title)
                .bold()
            
            Text(spotifyController.currentTrackArtist ?? "아티스트")
                .font(.title3)
                .bold()
            
            HStack {
                Text("0:00")
                    .font(.body)
                
                Spacer()
                
                Button("재생/일시정지") {
                    spotifyController.togglePlayPause()
                }.tint(.blue)
                
                Spacer()
                
                Text("\(spotifyController.currentTrackDuration ?? 999)")
                    .font(.body)
            }
            .padding(.top, 16)
            
            Divider()
                .padding(.top, 32)
            
            MusicController()
                .padding(.top, 32)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - MusicController

private struct MusicController: View {
    
    @EnvironmentObject private var spotifyController: SpotifyController
    
    var body: some View {
        HStack(spacing: 32) {
            Spacer()
            
            Button("Fix You") {
                Task {
                 await spotifyController.playFixyou()
                }
            }.tint(.blue)
            
            Button("미안해 미워해 사랑해") {
                spotifyController.play미안해미워해사랑해()
            }.tint(.blue)
            
            Button("Memories") {
                spotifyController.playMemories()
            }.tint(.blue)
            
            Spacer()
        }
    }
}

#Preview {
    SpotifyTestView()
}
