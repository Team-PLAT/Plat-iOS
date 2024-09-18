//
//  PlaylistDetailsView.swift
//  PLAT
//
//  Created by crownjoe on 9/16/24.
//

import SwiftUI

struct PlaylistDetailsView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var playlist: Playlist = MockDataBuilder.playlist
    @State private var showTrackDetail = false
    @State private var isrcs: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            
            PlayListInfo(playlist: playlist)
                .padding(.bottom, 10)
            
            PlayListPlayButton(isrcs: $isrcs)
                .padding(.bottom, 10)
            
            PlayListDetailView(playlist: playlist)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(playlist.trackList) { track in
                        PlayListRowView(showTrackDetail: $showTrackDetail, isrcs: $isrcs, track: track)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showTrackDetail) {
            if let trackId = musicControlUseCase.state.isPlayingTrack?.id {
                TrackDetailView()
                // TODO: trackId
                    .presentationBackground(.thinMaterial.opacity(0.5))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    // TODO: 뒤로 가기
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: SystemImage.back)
                    }
                    .foregroundStyle(.platPurple)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO: PlaylistDetailsEditView 뷰 이동 & fetch한 애들 넘기기
                } label: {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray9)
                        .overlay {
                            Image(systemName: SystemImage.pencil)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.platPurple)
                        }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO: 플리 삭제
                } label: {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray9)
                        .overlay {
                            Image(systemName: SystemImage.trash)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.platPurple)
                        }
                }
            }
        }
    }
}

// MARK: - PlayListInfo

private struct PlayListInfo: View {
    
    let playlist: Playlist
    
    private var playlistImageUrl: URL? {
        URL(string: playlist.imageUrl)
    }
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            AsyncImage(url: playlistImageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 220, height: 220)
                        .foregroundStyle(.gray9)
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
                                .foregroundStyle(.platPurple)
                            
                            Text("재생")
                                .font(.Body.body2)
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
            Button {
                musicControlUseCase.effect(.playRandomPlaylist(isrcs: isrcs))
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.shuffle)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.platPurple)
                            
                            Text("임의재생")
                                .font(.Body.body2)
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
        }
    }
}

// MARK: - PlayListDetailView

private struct PlayListDetailView: View {
    
    let playlist: Playlist
    
    var totalDurationInMinutes: Int {
        let totalDurationInSeconds = playlist.trackList.reduce(0) { $0 + $1.music.duration / 1000 }
        return Int(totalDurationInSeconds) / 60
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(spacing: 6) {
                Spacer()
                
                Text("\(playlist.trackList.count)곡")
                    .font(.Body.body5)
                    .foregroundStyle(.white)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(.gray9)
                
                Text("\(totalDurationInMinutes)분")
                    .font(.Body.body5)
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 18)
            .padding(.bottom, 9)
        }
    }
}

// MARK: - PlayListRowView

private struct PlayListRowView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var playlistMusic: Music?
    @Binding private(set) var showTrackDetail: Bool
    @Binding var isrcs: [String]
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    AlbumImage(playlistMusic: $playlistMusic, track: track)
                        .padding(.trailing, 10)
                        .padding(.leading, 18)
                    
                    TrackInfo(feedMusic: $playlistMusic, track: track)
                        .padding(.trailing, 40)
                    
                    Spacer()
                }
                .onTapGesture {
                    musicControlUseCase.state.isPlayingTrack = track
                    musicControlUseCase.effect(.setup(music: track.music))
                    showTrackDetail.toggle()
                }
                
                HStack(spacing: 0) {
                    Menu {
                        Button {
                            showTrackDetail.toggle()
                            musicControlUseCase.state.isPlayingTrack = track
                            musicControlUseCase.effect(.setup(music: track.music))
                        } label: {
                            Label("트랙 피드 조회", systemImage: SystemImage.searchFeed)
                        }
                        
                        Button(role: .destructive) {
                            // TODO: 플리에서 제거
                        } label: {
                            Label("플레이리스트에서 제거", systemImage: SystemImage.delete)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.red, .red)
                        }
                        
                    } label: {
                        Image(systemName: SystemImage.moreDetail)
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: -90))
                    }
                    .padding(.trailing, 18)
                }
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

private struct AlbumImage: View {
    
    @Binding private(set) var playlistMusic: Music?
    
    let track: Track
    
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

private struct TrackInfo: View {
    
    @Binding private(set) var feedMusic: Music?
    
    let track: Track
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(feedMusic?.title ?? "")
                .font(.Body.body3)
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                Text(feedMusic?.artist ?? "")
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
    PlaylistDetailsView()
        .environment(PreviewHelper.mockMusicControlUseCase)
}
