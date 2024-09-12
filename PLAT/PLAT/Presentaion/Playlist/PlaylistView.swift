//
//  PlaylistView.swift
//  PLAT
//
//  Created by 조우현 on 9/10/24.
//

import SwiftUI

// MARK: - PlaylistView

struct PlaylistView: View {
    @State var playlists: [Playlist]
    @State private var selectedPlaylistId: Playlist.ID?
    @State private var showPlaylistDetail: Bool = false
    @State private var searchText: String = ""
    var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return playlists
        } else {
            return playlists.filter { $0.title.localizedStandardContains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
//                HeaderView()
                ScrollView {
                    CreatePlaylistView()
                    ForEach(filteredPlaylists) { playlist in
                        VStack {
                            PlaylistSectionView(playlist: playlist)
                                .onTapGesture {
                                    // TODO: PlaylistDetailView로 이동
                                    selectedPlaylistId = playlist.id
                                    showPlaylistDetail.toggle()
                                }
                            DividerView()
                        }
                    }
                }
                .padding(.leading, 18)
                .padding(.vertical, 5)
            }
            .background(.platBackground)
            .tint(.white)
            .navigationTitle("플레이리스트")
        }
        .searchable(text: $searchText, prompt: "플레이리스트에서 찾기")
    }
}

// MARK: - HeaderView

//private struct HeaderView: View {
//    var body: some View {
//        HStack {
//            Text("플레이리스트")
//                .font(.Head.head1)
//                .padding()
//            
//            Spacer()
//        }
//    }
//}

// MARK: - PlaylistSectionView

struct PlaylistSectionView: View {
    let playlist: Playlist
    @State private var isShowDetailSheet: Bool = false
    
    var body: some View {
        HStack(spacing: 18) {
            AsyncImage(url: URL(string: playlist.imageUrl)) { img in
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
            
            Text("\(playlist.title)")
                .font(.Body.body2)
            
            Spacer()
            
            Button {
                isShowDetailSheet = true
            } label: {
                Image(.icnVerticalDots)
            }
            .padding(.trailing, 18)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - DividerView

private struct DividerView: View {
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

private struct CreatePlaylistView: View {
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
                                .frame(width: 28, height: 28)
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
    PlaylistView(playlists: MockDataBuilder.playlists)
}
