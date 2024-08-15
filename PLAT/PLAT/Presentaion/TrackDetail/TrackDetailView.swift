//
//  TrackDetailView.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - TrackDetailView

struct TrackDetailView: View {
    
    // TODO: 이후 상위에서 주입 받기
    // TODO: Stub 객체 교체하기
    @State private var trackDetailUseCase: TrackDetailUseCase = .init(
        track: MockDataBuilder.track,
        trackService: StubTrackService(),
        musicController: StubMusicController()
    )
    
    private var music: Music {
        trackDetailUseCase.track.music
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding(.leading, 16)
            
            Spacer()
            
            MusicView()
            
            MusicControllerView()
                .padding(.top, 24)
            
            // TODO: CurrentDuration 수정
            MusicSeekBar(
                currentDuration: music.duration / 2,
                totalDuration: music.duration
            )
            .padding(.horizontal, 16)
            .padding(.top, 36)
            
            MusicIndicator()
            
            Spacer()
        }
        .environment(trackDetailUseCase)
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(.imgMarker)
                
                Group {
                    if let placeName = trackDetailUseCase.state.place.name {
                        Text(placeName)
                        
                    } else {
                        Text(trackDetailUseCase.state.place.address)
                    }
                }
                .font(.Head.head2)
                .foregroundStyle(.white)
                
                Spacer()
                
                DismissButton {
                    dismiss()
                }
            }
            
            Text(trackDetailUseCase.state.place.address)
                .font(.Body.body3)
                .foregroundStyle(.white)
                .padding(.leading, 24)
        }
    }
}

// MARK: - MusicView

private struct MusicView: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    private var music: Music {
        trackDetailUseCase.track.music
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AlbumImage()
            
            Text(music.title)
                .font(.Head.head2)
                .foregroundStyle(.white)
                .padding(.top, 16)
            
            Text(music.artist)
                .font(.Head.head5)
                .foregroundStyle(.gray7)
                .padding(.top, 4)
        }
    }
}

// MARK: - AlbumImage

private struct AlbumImage: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    private var albumImageUrl: URL? {
        URL(string: trackDetailUseCase.track.music.albumImageUrl)
    }
    
    var body: some View {
        AsyncImage(url: albumImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - MusicControllerView

private struct MusicControllerView: View {
    var body: some View {
        HStack(spacing: 24) {
            MusicControllerCell(
                systemImage: "heart",
                tapAction: {
                    
                }
            )
            
            MusicControllerCell(
                systemImage: "text.badge.plus",
                tapAction: {
                    
                }
            )
            
            MusicControllerCell(
                systemImage: "repeat",
                tapAction: {
                    
                }
            )
            
            MusicControllerCell(
                systemImage: "ellipsis.circle",
                tapAction: {
                    
                }
            )
        }
    }
}

// MARK: - MusicControllerCell

private struct MusicControllerCell: View {
    
    let systemImage: String
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.gray9)
                
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrackDetailView()
}
