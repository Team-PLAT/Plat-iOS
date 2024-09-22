//
//  PlaylistDetailsEditView.swift
//  PLAT
//
//  Created by crownjoe on 9/17/24.
//

import SwiftUI

struct PlaylistDetailsEditView: View {
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(PathModel.self) private var pathModel
    
    @State var playlist: Playlist = MockDataBuilder.playlist
    
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
                        PlayListRowView(track: track, onDelete: { trackToDelete in
                            deleteTrack(trackToDelete)
                        })
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
                    Text("취소")
                    .foregroundStyle(.platPurple)
                }
            }
        
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO: 완료
                } label: {
                    Text("완료")
                    .foregroundStyle(.platPurple)
                }
            }
        }
    }
    private func deleteTrack(_ track: Track) {
        playlist.trackList.removeAll { $0.id == track.id }
    }
}

// MARK: - PlayListInfo

private struct PlayListInfo: View {
    
    @State private var isPhotoAlbumSheet = false
    @State private var selectedImage: UIImage?
    
    @Binding var playlist: Playlist
    
    private var playlistImageUrl: URL? {
        URL(string: playlist.imageUrl)
    }
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            Button {
                isPhotoAlbumSheet.toggle()
            } label: {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay {
                            Circle()
                                .frame(width: 61, height: 61)
                                .foregroundStyle(.platPurple)
                            
                            Image(systemName: SystemImage.camera)
                                .foregroundStyle(.white)
                        }
                } else {
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
                
            }
            .padding(.bottom, 16)
            .sheet(isPresented: $isPhotoAlbumSheet) {
                PhotoPicker(selectedImage: $selectedImage)
                    .onChange(of: selectedImage) {
                        if selectedImage != nil {
                            // TODO: 이미지 URL 업로드 로직
                        }
                    }
            }
            
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

// MARK: - NewTrackAdd

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

// MARK: - PlayListRowView

private struct PlayListRowView: View {
    
    let track: Track
    let onDelete: (Track) -> Void
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                Button {
                    // TODO: 트랙 삭제
                    onDelete(track)
                } label: {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.red)
                        .overlay {
                            Image(systemName: SystemImage.minus)
                                .foregroundColor(.white)
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
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    let track: Track
    
    private var albumImageUrl: URL? {
        URL(string: playlistUseCase.selectedPlaylist?.imageUrl ?? "")
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
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
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
    PlaylistDetailsEditView()
        .injectDIContainer()
}
