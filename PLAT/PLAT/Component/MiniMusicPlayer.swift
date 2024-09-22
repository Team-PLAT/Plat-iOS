//
//  MiniMusicPlayer.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import SwiftUI

// MARK: - MiniMusicPlayer

struct MiniMusicPlayer: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding private(set) var isPaused: Bool
    @Binding private(set) var track: Track?
    
    let currentDuration: Double
    let totalDuration: Double
    
    private var progress: Double {
        currentDuration / totalDuration
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 14) {
                AlbumImage(track: track)
                Content(track: track)
                Spacer()
                PlaybackButton(isPaused: $isPaused, track: track)
            }
            .padding(.horizontal, 12)
            
            ProgressView(value: progress)
                .tint(.platPurple)
                .background(.platBlack)
        }
        .padding(.top, 12)
        .background(.platBlack)
        .onTapGesture {
            pathModel.presentFullScreenCover(.trackDetail)
        }
    }
}

// MARK: - AlbumImage

private struct AlbumImage: View {
    
    let track: Track?
    
    private var muiscImageUrl: URL? {
        guard let urlString = track?.music.albumImageUrl else { return nil }
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
    
    let track: Track?
    
    private var userOfTrack: String {
        if let nickname = track?.user.nickname {
            return nickname + "의 트랙"
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text(track?.music.title ?? "")
                    .font(.Body.body2)
                
                Circle()
                    .frame(width: 2, height: 2)
                
                Text(track?.music.artist ?? "")
                    .font(.Body.body5)
            }
            
            Text(userOfTrack)
                .font(.Body.body2)
        }
        .foregroundStyle(.gray3)
    }
}

// MARK: - PlaybackButton

private struct PlaybackButton: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding private(set) var isPaused: Bool
    
    let track: Track?
    
    var body: some View {
        Button {
            musicControlUseCase.effect(.togglePlayback)
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
            track: .constant(MockDataBuilder.track),
            currentDuration: 0.0,
            totalDuration: 4.0
        )
    }
    .environment(PreviewHelper.mockMusicControlUseCase)
}
