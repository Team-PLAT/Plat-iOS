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
                ScrollView {
                    CreatePlaylistView()
                    
                    ForEach(filteredPlaylists) { playlist in
                        Button {
                            selectedPlaylistId = playlist.id
                            showPlaylistDetail.toggle()
                        } label: {
                            VStack {
                                PlaylistSectionView(playlist: playlist)
                                DividerView()
                            }
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
                isShowDetailSheet.toggle()
            } label: {
                Image(.icnVerticalDots)
            }
            .padding(.trailing, 18)
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $isShowDetailSheet) {
            DetailSheetView(playlist: playlist)
        }
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
                // TODO: AppendPlaylistView로 이동
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

// MARK: - DetailSheetView

private struct DetailSheetView: View {
    let playlist: Playlist
    
    var body: some View {
        VStack {
            DetailPlaylistButtonView(playlist: playlist)

            DetailInfoView()
            
            DetailBottonsView(playlist: playlist)
                .padding()
        }
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(30)
    }
}

// MARK: - DetailPlaylistButtonView

private struct DetailPlaylistButtonView: View {
    let playlist: Playlist
    @State private var selectedPlaylistId: Playlist.ID?
    @State private var showPlaylistDetail: Bool = false
    
    var body: some View {
        Button {
            // TODO: PlaylistDetailView로 이동
            selectedPlaylistId = playlist.id
            showPlaylistDetail.toggle()
        } label: {
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
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 16)
                    .foregroundStyle(.gray8)
            }
        }
        .padding(.horizontal)
        .padding(.top, 36)
    }
}

// MARK: - DetailInfoView

private struct DetailInfoView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("트랙 PD 정보")
                    .font(.Body.body4)
                
                Text("\(MockDataBuilder.playlist.trackList[0].platter.nickname)")
                    .font(.Body.body5 )
                    .foregroundStyle(.gray7)
            }
            Spacer()
        }
        .padding()
    }
}

// MARK: - DetailBottonsView

private struct DetailBottonsView: View {
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    let playlist: Playlist
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlaylistId: Playlist.ID?
    @State private var showPlaylistDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            Button {
                playlistUseCase.playOnDevice()
            } label: {
                HStack {
                    Image(systemName: "play.circle")
                    Text("기기에서 재생")
                        .font(.Body.body3)
                    Spacer()
                }
            }
            
            Button {
                // TODO: PlaylistDetailView의 편집모드로 바로 이동
                selectedPlaylistId = playlist.id
                showPlaylistDetail = true
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("플레이리스트 편집")
                        .font(.Body.body3)
                    Spacer()
                }
            }
            
            Button {
                playlistUseCase.deletePlaylist()
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("플레이리스트 삭제")
                        .font(.Body.body3)
                    Spacer()
                }
            }
        }
        Spacer()
        
        Divider()
        
        Button {
            dismiss()
        } label: {
            Text("닫기")
                .font(.Body.body1)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview {
    PlaylistView(playlists: MockDataBuilder.playlists)
        .environment(PreviewHelper.mockPlaylistUseCase)
}
