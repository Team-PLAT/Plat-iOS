//
//  PlatProcessingFullScreen.swift
//  PLAT
//
//  Created by 박준우 on 8/18/24.
//

import SwiftUI

struct PlatProcessingFullScreen: View {
    @State var isCompleteLoading = false
    @Binding var playList: Playlist?
    
    var body: some View {
        VStack {
            PlattingDismissButton()
            Spacer()
            if isCompleteLoading {
                PlattingPlayListView(playList: $playList)
                
            } else {
                if let trackList = playList?.trackList {
                    PlattingLoadingView(trackList: trackList)
                } else {
                    Text("Loading failed")
                }
            }
        }
        .presentationBackground(.black.opacity(0.8))
        
        // TODO: 플래팅로딩뷰에서 플래팅플레이리스트뷰로 넘어가는 로직 구현하기
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                isCompleteLoading = true
            }
        }
    }
}

// MARK: - PlattingDismissButton

private struct PlattingDismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Spacer()
            DismissButton {
                // TODO: 만들어진 플레이리스트 인스턴스 삭제 필요?
                dismiss()
            }
        }
    }
}

// MARK: - PlattingLoadingView

private struct PlattingLoadingView: View {
    var trackList: [Track]
    var body: some View {
        VStack {
            // TODO: 트랙들의 이미지 그리는 로직 추가하기
            ForEach(trackList) { list in
                if let imgUrl = list.imageUrl {
                    AsyncImage(url: URL(string: imgUrl)) { img in
                        if let image = img.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            Spacer()
            Text("Platting...")
                .font(.Head.head3)
                .padding(.bottom, 104)
        }
    }
}

// MARK: - PlattingLoadingView

private struct PlattingPlayListView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var showTrackDetail = false
    @State private var isrcs: [String] = []
    
    @Binding var playList: Playlist?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                PlattingPlayListInfo(playlist: playList ?? Playlist(
                    id: 0001,
                    title: "플레이리스트 가져오기 실패",
                    imageUrl: "",
                    trackList: []
                ))
                .padding(.bottom, 10)
                
                PlayListPlayButton(isrcs: $isrcs)
                    .padding(.bottom, 10)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray9)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray9)
                    .padding(.leading, 46)
                
                VStack(spacing: 0) {
                    ForEach(playList?.trackList ?? []) { track in
                        PlayListRowView(isrcs: $isrcs, track: track)
                    }
                }
            }
        }
    }
}

// MARK: - PlayListInfo

private struct PlattingPlayListInfo: View {
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    let playlist: Playlist
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            
            AsyncImage(url: URL(string: playlist.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 220, height: 220)
                        .foregroundStyle(LinearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                }
            }
            .padding(.bottom, 16)
            
            Text(playlist.title)
                .font(.Head.head2)
                .foregroundStyle(.white)
                .frame(width: 213, height: 44, alignment: .center)
                .padding(.bottom, -12)
            
            Text(playlist.createdDate.yearMonthDayFormat)
                .font(.Body.body1)
                .foregroundStyle(.gray7)
                .frame(width: 160, height: 44, alignment: .center)
            
        }
    }
}

// MARK: - PlayListPlayButton

private struct PlayListPlayButton: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding var isrcs: [String]
    
    var body: some View {
        HStack(spacing: 27) {
            Button {
                musicControlUseCase.effect(.playPlaylist(isrcs: isrcs))
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.play)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white)
                            
                            Text("재생")
                                .font(.Body.body2)
                                .foregroundStyle(.white)
                        }
                    }
            }
            
            Button {
                // TODO: 저장 구현
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.savePlaylist)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white)
                            
                            Text("플레이리스트 저장")
                                .font(.Body.body2)
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
    }
}

// MARK: - PlayListRowView

private struct PlayListRowView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PathModel.self) private var pathModel
    
    @State private var playlistMusic: Music?
    @Binding var isrcs: [String]
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PlattingAlbumImage(playlistMusic: $playlistMusic)
                    .padding(.trailing, 10)
                    .padding(.leading, 18)
                
                PlattingTrackInfo(playlistMusic: $playlistMusic)
                    .padding(.trailing, 40)
                
                Spacer()
            }
            .padding(.vertical, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
                .padding(.leading, 46)
            
        }
        .onAppear {
            Task {
                playlistMusic = await musicControlUseCase.fetchMusicInfoApi(music: track.music)
                
                if let currentIsrc = playlistMusic?.isrc {
                    isrcs.append(currentIsrc)
                    print("🍔🍔🍔🍔", isrcs)
                }
            }
        }
    }
}

// MARK: - AlbumImage

private struct PlattingAlbumImage: View {
    
    @Binding private(set) var playlistMusic: Music?
    
    private var albumImageUrl: URL? {
        URL(string: playlistMusic?.albumImageUrl ?? "")
    }
    
    var body: some View {
        AsyncImage(url: albumImageUrl) { phase in
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

// MARK: - TrackInfo

private struct PlattingTrackInfo: View {
    
    @Binding private(set) var playlistMusic: Music?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(playlistMusic?.title ?? "")
                .font(.Body.body3)
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                Text(playlistMusic?.artist ?? "")
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(.gray7)
                
                //                if track.platter is User {
                Text("직접 추가됨")
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
                //                } else {
                //                    Text("\(track.platter.nickname)의 트랙")
                //                        .font(.Body.body5)
                //                        .foregroundStyle(.gray7)
                //                }
                
            }
        }
    }
}

#Preview {
    PlatProcessingFullScreen(playList: .constant(MockDataBuilder.playlist))
        .injectDIContainer()
}
