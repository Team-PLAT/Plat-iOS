//
//  MiniMusicPlayer.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import SwiftUI

// MARK: - MiniMusicPlayer

struct MiniMusicPlayer: View {
    
    @Binding private(set) var isPaused: Bool
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 14) {
                AlbumImage(track: track)
                Content(track: track)
                Spacer()
                PlaybackButton(isPaused: $isPaused)
            }
            
            ProgressView(value: 0.5)
                .tint(.platPurple)
                .background(.platBlack)
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .background(.platBlack)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            print("음악 재생 화면 이동")
            // TODO: 음악 재생 화면 이동
        }
    }
}

// MARK: - AlbumImage

private struct AlbumImage: View {
    
    let track: Track
    
    private var muiscImageUrl: URL? {
        let urlString = track.music.albumImageUrl
        return URL(string: urlString)
    }
    
    var body: some View {
        AsyncImage(url: muiscImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - Content

private struct Content: View {
    
    let track: Track
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text(track.music.title)
                    .font(.Body.body2)
                
                Circle()
                    .frame(width: 2, height: 2)
                
                Text(track.music.artist)
                    .font(.Body.body5)
            }
            
            Text(track.platter.nickname + "의 트랙")
                .font(.Body.body2)
        }
        .foregroundStyle(.gray3)
    }
}

// MARK: - PlaybackButton

private struct PlaybackButton: View {
    
    @Binding private(set) var isPaused: Bool
    
    var body: some View {
        Button {
            isPaused.toggle()
        } label: {
            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 18, height: 18)
                .foregroundStyle(.gray8)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray6.ignoresSafeArea()
        
        MiniMusicPlayer(
            isPaused: .constant(false),
            track: MockDataBuilder.track
        )
    }
}
