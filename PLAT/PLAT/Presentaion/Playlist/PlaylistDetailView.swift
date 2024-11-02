//
//  PlaylistDetailView.swift
//  PLAT
//
//  Created by 박준우 on 9/17/24.
//

import SwiftUI
import Kingfisher

struct PlaylistDetailView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var showTrackDetail = false
    @State private var isrcs: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                PlayListInfo()
                    .padding(.bottom, 10)
                
                PlayListPlayButton(isrcs: $isrcs)
                    .padding(.bottom, 10)
                
                PlayListDetailView()
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray9)
                
                PlaylistDetailNewTrackButton()
                    .padding(.vertical, 10)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray9)
                    .padding(.leading, 46)
                
                VStack(spacing: 0) {
                    ForEach(playlistUseCase.state.selectedPlaylist?.trackList ?? []) { track in
                        PlayListRowView(isrcs: $isrcs, track: track)
                            .onTapGesture {
                                // TODO: iOS 18 버전 미만에서 터짐💣
                                musicControlUseCase.state.currentTrack = track
//                                musicControlUseCase.effect(.setup(music: track.music))
                                pathModel.presentFullScreenCover(.trackDetail)
                            }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    pathModel.pop()
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: SystemImage.back)
                    }
                    .foregroundStyle(.platPurple)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    pathModel.push(.playlistDetailsEditView)
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
                    Task {
                        await playlistUseCase.deletePlaylist(playlistId: Int(playlistUseCase.selectedPlaylist?.id ?? 0001))
                        
                        playlistUseCase.fetchPlaylists {
                            pathModel.pop()
                        }
                    }
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
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    private var playlistImageUrl: URL? {
        return URL(string: playlistUseCase.state.selectedPlaylist?.imageUrl ?? "")
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(playlistImageUrl)
                .placeholder {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 220, height: 220)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .indigo],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.bottom, 16)
            
            Text(playlistUseCase.state.selectedPlaylist?.title ?? "플레이리스트 가져오기 실패")
                .font(.Head.head2)
                .foregroundStyle(.white)
                .frame(width: 213, height: 44, alignment: .center)
                .padding(.bottom, -12)
            
            Text(playlistUseCase.state.selectedPlaylist?.createdDate.yearMonthDayFormat ?? Date().yearMonthDayFormat)
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
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    // TODO: 항상 0분으로 표시되는 오류
    var totalDurationInMinutes: Int {
        let totalDurationInSeconds = playlistUseCase.state.selectedPlaylist?.trackList.reduce(0) { $0 + $1.music.duration / 1000 }
        return Int(totalDurationInSeconds ?? 0) / 60
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(spacing: 6) {
                Spacer()
                
                Text("\(playlistUseCase.state.selectedPlaylist?.trackList.count ?? 0)곡")
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

// MARK: - PlaylistDetailNewTrackButton

private struct PlaylistDetailNewTrackButton: View {
    
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        Button {
            pathModel.presentSheet(.trackAppendSearch)
        } label: {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.platPurple)
                            .padding(12)
                    }
                    .frame(width: 40, height: 40)
                
                Text("새로운 트랙 생성")
                    .font(.Body.body2)
                
                Spacer()
            }
        }
        .padding(.horizontal, 18)
    }
}

// MARK: - PlayListRowView

private struct PlayListRowView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PathModel.self) private var pathModel
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    @State private var playlistMusic: Music?
    @Binding var isrcs: [String]
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    AlbumImage(playlistMusic: $playlistMusic)
                        .padding(.trailing, 10)
                        .padding(.leading, 18)
                    
                    TrackInfo(playlistMusic: $playlistMusic)
                        .padding(.trailing, 40)
                    
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Menu {
                        Button {
                            musicControlUseCase.state.currentTrack = track
//                            musicControlUseCase.effect(.setup(music: track.music))
                            pathModel.presentFullScreenCover(.trackDetail)
                        } label: {
                            Label("트랙 피드 조회", systemImage: SystemImage.searchFeed)
                        }
                        
                        Button(role: .destructive) {
                            Task {
                                await playlistUseCase.deleteTrackFromPlaylist(playlistId: Int(playlistUseCase.state.selectedPlaylistId ?? 0001), trackId: Int(track.id))
                                playlistUseCase.fetchPlaylistDetail(playlistId: Int(playlistUseCase.state.selectedPlaylistId ?? 0001))
                            }
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
                let result = await musicControlUseCase.fetchMusic(from: track)
                switch result {
                case .success(let success):
                    playlistMusic = success
                case .failure(let failure):
                    print(failure)
                }
                
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
    
    private var albumImageUrl: URL? {
        URL(string: playlistMusic?.albumImageUrl ?? "")
    }
    
    var body: some View {
        KFImage(albumImageUrl)
            .placeholder {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray9)
            }
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - TrackInfo

private struct TrackInfo: View {
    
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
    PlaylistDetailView()
        .injectDIContainer()
}
