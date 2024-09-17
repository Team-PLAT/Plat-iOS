//
//  PlaylistDetailsView.swift
//  PLAT
//
//  Created by crownjoe on 9/16/24.
//

import SwiftUI

struct PlaylistDetailsView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State var playlist: Playlist = MockDataBuilder.playlist
    
    var body: some View {
        VStack(spacing: 0) {
            PlayListEditButton()
                .padding(.leading, 300)
            PlayListInfo(playlist: playlist)
                .padding(.bottom, 10)
            PlayListPlayButton()
                .padding(.bottom, 10)
            PlayListDetailView(playlist: playlist)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(playlist.trackList) { track in
                        PlayListRowView(track: track)
                    }
                }
            }
        }
    }
}

private struct PlayListEditButton: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                // TODO: 수정
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
            
            Button {
                // TODO: 삭제
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

private struct PlayListPlayButton: View {
    var body: some View {
        HStack(spacing: 27) {
            Button {
                // TODO: 재생
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
                // TODO: 임의재생
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

private struct PlayListRowView: View {
    
    let track: Track
    
    // TODO: 음악 재생
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                AlbumImage(track: track)
                    .padding(.trailing, 10)
                    .padding(.leading, 18)
                
                TrackInfo(track: track)
                    .padding(.trailing, 40)
                
                Spacer()
                
                Menu {
                    Button {
                        // TODO: 플리에서 제거 및 색 바꾸기 이슈
                    } label: {
                        Label("플레이리스트에서 제거", systemImage: SystemImage.delete)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, .red)
                    }
                    
                    Button {
                        // TODO: 트랙 피드 조회
                    } label: {
                        Label("트랙 피드 조회", systemImage: SystemImage.searchFeed)
                    }
                    
                } label: {
                    Image(systemName: SystemImage.moreDetail)
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
}

private struct AlbumImage: View {
    
    let track: Track
    
    private var albumImageUrl: URL? {
        URL(string: track.music.albumImageUrl)
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

private struct TrackInfo: View {
    
    let track: Track
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(track.music.title)
                .font(.Body.body3)
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                Text(track.music.artist)
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(.gray7)
                
                if track.platter is User {
                    Text("직접 추가됨")
                        .font(.Body.body5)
                        .foregroundStyle(.gray7)
                } else {
                    Text("\(track.platter.nickname)의 트랙")
                        .font(.Body.body5)
                        .foregroundStyle(.gray7)
                }
                
            }
        }
    }
}

#Preview {
    PlaylistDetailsView()
        .environment(PreviewHelper.mockMusicControlUseCase)
}
