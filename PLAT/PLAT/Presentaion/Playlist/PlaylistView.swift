//
//  PlaylistView.swift
//  PLAT
//
//  Created by 조우현 on 9/10/24.
//

import SwiftUI

// MARK: - PlaylistView

struct PlaylistView: View {
    @State var playlist: [Playlist]
    
    var body: some View {
        VStack {
            PlaylistSectionView(playlist: $playlist)
        }
    }
}

// MARK: - ListSectionView

struct PlaylistSectionView: View {
    @Binding var playlist: [Playlist]
    @State private var isShowDetailSheet: Bool = false
    
    var body: some View {
        ScrollView {
            CreatePlaylistView()
            ForEach(playlist.indices, id: \.self) { index in
                
                let list = playlist[index]
                VStack {
                    HStack(spacing: 18) {
                        AsyncImage(url: URL(string: list.imageUrl)) { img in
                            if let image = img.image {
                                image
                                    .resizable()
                                    .frame(width: 68, height: 68)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 68, height: 68)
                            }
                        }
                        
                        Text("\(list.title)")
                            .font(.Body.body2)
                        
                        Spacer()
                        
                        Button {
                            isShowDetailSheet = true
                        } label: {
                            Image(.icnVerticalDots)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    DividerView()
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 5)
    }
}

// MARK: - DividerView

struct DividerView: View {
    var body: some View {
        HStack {
            Spacer()
            Rectangle()
                .frame(width: 300, height: 1)
                .foregroundStyle(.gray9)
                .opacity(0.7)
        }
    }
}

// MARK: - CreatePlaylistView

struct CreatePlaylistView: View {
    var body: some View {
        VStack {
            Button {
                
            } label: {
                HStack(spacing: 18) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 68, height: 68)
                        .foregroundStyle(.gray9)
                        .overlay {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.platPurple)
                        }
                    
                    Text("새로운 플레이리스트 생성")
                        .font(.Body.body3)
                        .foregroundStyle(.platPurple)
                    
                    Spacer()
                }
            }
            DividerView()
        }
    }
}

// MARK: - Preview
#Preview {
    PlaylistView(playlist: MockDataBuilder.playlist)
}
