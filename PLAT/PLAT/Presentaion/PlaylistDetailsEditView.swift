//
//  PlaylistDetailsEditView.swift
//  PLAT
//
//  Created by crownjoe on 9/17/24.
//

import SwiftUI

struct PlaylistDetailsEditView: View {
    
    @State var playlist: Playlist = MockDataBuilder.playlist
    //    @Binding var playlist: Playlist
    
    var body: some View {
        VStack(spacing: 0) {
            
            PlayListInfo(playlist: $playlist)
                .padding(.bottom, 17)
            
            NewTrackAdd()
            
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

private struct PlayListInfo: View {
    
    @Binding var playlist: Playlist
    
    private var playlistImageUrl: URL? {
        URL(string: playlist.imageUrl)
    }
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            Button {
                // TODO: 사진 바꾸기
            } label: {
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
                .overlay {
                    Circle()
                        .frame(width: 61, height: 61)
                        .foregroundStyle(.platPurple)
                    
                    Image(systemName: SystemImage.camera)
                        .foregroundStyle(.white)
                }
            }
            .padding(.bottom, 16)
            
            TextField(" ", text: $playlist.title)
                .font(.Head.head2)
                .frame(height: 44, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.bottom, 4)
            
            Rectangle()
                .frame(width: 357, height: 1)
                .foregroundColor(.gray9)
                .padding(.bottom, 12)
            
            HStack {
                Text("생성일자")
                    .font(.Body.body1)
                    .foregroundStyle(.gray7)
                    .padding(.leading, 18)
                
                Spacer()
                
                Text(playlist.createdDate.yearMonthDayFormat)
                    .font(.Body.body1)
                    .foregroundStyle(.gray7)
                    .padding(.trailing, 18)
                
            }
            .frame(height: 44)
            .padding(.bottom, 12)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
        }
    }
}

private struct NewTrackAdd: View {
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                // TODO: 트랙 추가
            } label: {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray9)
                    .overlay {
                        Image(systemName: SystemImage.trackPlus)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.platPurple)
                    }
            }
            .padding(.leading, 18)
            
            Text("새로운 트랙 생성")
                .font(.Body.body2)
                .foregroundStyle(.white)
            
            Spacer()
            
        }
        .padding(.trailing, 18)
        .padding(.bottom, 17)
    }
}

private struct PlayListRowView: View {
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                Button {
                    // TODO: 트랙 삭제
                } label: {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.red)
                        .overlay {
                            Image(systemName: SystemImage.minus)
                        }
                }
                .padding(.leading, 18)
                
                AlbumImage(track: track)
                    .padding(.horizontal, 10)
                
                TrackInfo(track: track)
                    .padding(.trailing, 40)
                
                Spacer()
                
                Button {
                    // TODO: 트랙 이동
                } label: {
                    Image(systemName: SystemImage.trackDetail)
                        .foregroundColor(.gray9)
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
    PlaylistDetailsEditView()
}
