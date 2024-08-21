//
//  TrackAppendToPlaylistSheet.swift
//  PLAT
//
//  Created by 김민준 on 8/21/24.
//

import SwiftUI

// MARK: - TrackAppendToPlaylistSheet

struct TrackAppendToPlaylistSheet: View {
    
    var body: some View {
        ZStack {
            Color.platBlack.ignoresSafeArea()
            VStack(spacing: 0) {
                PagingScrollView()
                    .safeAreaPadding([.horizontal], 150)
            }
        }
    }
}

// MARK: - PagingScrollView

private struct PagingScrollView: View {
    
    @State private var scrollPosition: Int? = 0
    
    let playlists: [Playlist] = Array(repeating: MockDataBuilder.playlist, count: 20)
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<playlists.count, id: \.self) { index in
                        ListCell(playlist: playlists[index])
                            .id(index)
                            .zIndex(scrollPosition == index ? 1 : 0)
                            .containerRelativeFrame(.horizontal, alignment: .center)
                            .scrollTransition { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .animation(.smooth, value: scrollPosition)
        }
        .onChange(of: scrollPosition) { _, value in
            // TODO: 게시글 확인
        }
    }
}

// MARK: - ListCell

private struct ListCell: View {
    
    let playlist: Playlist
    
    private var imageURL: URL? {
        URL(string: playlist.imageUrl)
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 136, height: 136)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                RoundedRectangle(cornerRadius: 18)
                    .frame(width: 136, height: 136)
                    .foregroundStyle(.gray9)
            }
        }
        .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    TrackAppendToPlaylistSheet()
}
