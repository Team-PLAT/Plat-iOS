//
//  TrackAppendToPlaylistSheet.swift
//  PLAT
//
//  Created by 김민준 on 8/21/24.
//

import SwiftUI

// MARK: - TrackAppendToPlaylistSheet

struct TrackAppendToPlaylistSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var scrollPosition: Int? = 0
    
    let playlists: [Playlist] = Array(repeating: MockDataBuilder.playlist, count: 20)
    
    var body: some View {
        ZStack {
            Color.platBlack.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                
                PagingScrollView(scrollPosition: $scrollPosition, playlists: playlists)
                    .safeAreaPadding([.horizontal], 150)
                    .padding(.bottom, 32)
                
                AddButton(title: "\(playlists[scrollPosition ?? 0].title)") {
                    // TODO: 플레이리스트에 추가
                    dismiss()
                }
                .padding(.bottom, 16)
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(286)])
    }
}

// MARK: - PagingScrollView

private struct PagingScrollView: View {
    
    @Binding private(set) var scrollPosition: Int?
    
    let playlists: [Playlist]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
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
            .frame(height: 136)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .animation(.smooth, value: scrollPosition)
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

// MARK: - AddButton

private struct AddButton: View {
    
    let title: String
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "text.badge.plus")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                
                Text("\(title) 추가")
                    .font(.Body.body4)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .frame(height: 32)
            .background(.gray9)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

// MARK: - Preview

#Preview {
    TrackAppendToPlaylistSheet()
}
