//
//  PlaylistView.swift
//  PLAT
//
//  Created by 조우현 on 9/10/24.
//

import SwiftUI

// MARK: - PlaylistView

struct PlaylistView: View {
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(PathModel.self) private var pathModel
    
    @State private var selectedPlaylistId: Playlist.ID?
    @State private var searchText: String = ""
    @State private var searchTimer: Timer?
    @State private var filteredPlaylists: [Playlist] = []
    
    var body: some View {
        VStack {
            HeaderView(searchText: $searchText)
            
            ScrollView {
                CreatePlaylistView()
                
                ForEach(filteredPlaylists) { playlist in
                    Button {
                        selectedPlaylistId = playlist.id
                        playlistUseCase.effect(.updateSelectedPlaylistId(selectedPlaylistId ?? 0))
                        playlistUseCase.fetchPlaylistDetail(playlistId: Int(selectedPlaylistId ?? 0))
                        pathModel.push(.playlistDetail)
                    } label: {
                        VStack {
                            PlaylistSectionView(selectedPlaylistId: $selectedPlaylistId, playlist: playlist)
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
        .onAppear {
            playlistUseCase.fetchPlaylists {
                filteredPlaylists = playlistUseCase.state.playlists
            }
        }
        .onChange(of: searchText) {
            searchTimer?.invalidate()
            searchTimer = nil
            
            self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                if searchText == "" {
                    playlistUseCase.fetchPlaylists {
                        filteredPlaylists = playlistUseCase.state.playlists
                    }
                } else {
                    playlistUseCase.searchPlaylist(title: searchText) {
                        filteredPlaylists = playlistUseCase.state.searchPlaylists
                    }
                }
            }
        }
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Text("플레이리스트")
                    .font(.Head.head1)
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray8)
                    .padding(.leading, 10)
                
                TextField("", text: $searchText, prompt: Text("플레이리스트에서 찾기")
                    .foregroundStyle(.gray8)
                    .font(.Body.body3))
                    .foregroundStyle(.white)
                    .tint(.platPurple)
                
                Spacer()
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.gray8)
                            .padding(.leading, 10)
                    }
                    .padding(.trailing, 10)
                }
            }
            .frame(height: 42)
            .background {
                RoundedRectangle(cornerRadius: 8).fill(.platBlack)
            }
        }
        .padding()
    }
}

// MARK: - PlaylistSectionView

private struct PlaylistSectionView: View {
    
    @State private var isShowDetailSheet: Bool = false
    @Binding var selectedPlaylistId: Playlist.ID?
    
    let playlist: Playlist
    
    var body: some View {
        HStack(spacing: 18) {
            PlaylistImageView(imageUrl: playlist.imageUrl)
            
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
            DetailSheetView(selectedPlaylistId: $selectedPlaylistId, playlist: playlist)
        }
    }
}

// MARK: - PlaylistImageView

private struct PlaylistImageView: View {
    
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { img in
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
    
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        VStack {
            Button {
                pathModel.presentSheet(.appendPlaylist)
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
    
    @Binding var selectedPlaylistId: Playlist.ID?
    
    let playlist: Playlist
    
    var body: some View {
        VStack {
            DetailPlaylistButtonView(playlist: playlist)
            
            DetailInfoView()
            
            DetailButtonsView(selectedPlaylistId: $selectedPlaylistId, playlist: playlist)
            
            Spacer()
            
            DetailSheetCloseButtonView()
        }
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(30)
    }
}

// MARK: - DetailPlaylistButtonView

private struct DetailPlaylistButtonView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPlaylistId: Playlist.ID?
    
    let playlist: Playlist

    var body: some View {
        Button {
            selectedPlaylistId = playlist.id
            pathModel.push(.playlistDetail)
            dismiss()
        } label: {
            HStack(spacing: 18) {
                PlaylistImageView(imageUrl: playlist.imageUrl)
                
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
    
    let trackList = MockDataBuilder.playlist.trackList
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("트랙 PD 정보")
                    .font(.Body.body4)
                    .padding(.bottom, 2)
                
                Text(formatNicknames(trackList))
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
            }
            Spacer()
        }
        .padding()
    }
}

// MARK: - DetailButtonsView

private struct DetailButtonsView: View {
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PathModel.self) private var pathModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedPlaylistId: Playlist.ID?
    @State private var currentIsrcs: [String] = []
    
    let playlist: Playlist
    
    var body: some View {
        VStack(spacing: 32) {
            Button {
                selectedPlaylistId = playlist.id
                playlistUseCase.effect(.updateSelectedPlaylistId(selectedPlaylistId ?? 0))
                currentIsrcs = playlistUseCase.getPlaylistIsrcs() ?? []
                musicControlUseCase.effect(.playPlaylist(isrcs: currentIsrcs))
            } label: {
                HStack {
                    Image(systemName: "play.circle")
                    Text("기기에서 재생")
                        .font(.Body.body3)
                    Spacer()
                }
            }
            
            Button {
                selectedPlaylistId = playlist.id
                pathModel.push(.playlistDetailsEditView)
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("플레이리스트 편집")
                        .font(.Body.body3)
                    Spacer()
                }
            }
            
            Button {
                playlistUseCase.deletePlaylist(playlistId: Int(playlist.id))
                // TODO: 플리 삭제 api 연결
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("플레이리스트 삭제")
                        .font(.Body.body3)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

// MARK: - DetailSheetCloseButtonView

private struct DetailSheetCloseButtonView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 400, height: 1)
                .foregroundStyle(.gray9)
                .opacity(0.7)
            
            Button {
                dismiss()
            } label: {
                Text("닫기")
                    .font(.Body.body1)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

// MARK: - Functions

/// 트랙PD 정보에서 인원수에 따른 표시방법을 다르게 하기 위한 함수
private func formatNicknames(_ tracks: [Track]) -> String {
    
    let nicknames = tracks.map { $0.user.nickname }
    let count = nicknames.count
    
    if count > 3 {
        let displayedNicknames = nicknames.prefix(3).joined(separator: ", ")
        let additionalCount = count - 3
        return "\(displayedNicknames) 외 \(additionalCount)명"
    } else {
        return nicknames.joined(separator: ", ")
    }
}

// MARK: - Preview

#Preview {
    PlaylistView()
        .injectDIContainer()
}
