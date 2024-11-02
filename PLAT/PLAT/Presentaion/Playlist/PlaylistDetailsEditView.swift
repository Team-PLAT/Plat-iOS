//
//  PlaylistDetailsEditView.swift
//  PLAT
//
//  Created by crownjoe on 9/17/24.
//

import SwiftUI
import Kingfisher

struct PlaylistDetailsEditView: View {
    @Environment(PathModel.self) private var pathModel
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    @State private var selectedImage: UIImage?
    @State private var selectedPlaylist: Playlist = Playlist(
        id: 0001,
        title: "플레이리스트 가져오기 실패",
        imageUrl: "",
        trackList: []
    )
    
    var body: some View {
        VStack(spacing: 0) {
            
            PlayListEditInfo(selectedImage: $selectedImage, selectedPlaylist: $selectedPlaylist)
                .padding(.bottom, 17)
            
            NewTrackAdd()
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
            
            List {
                ForEach(selectedPlaylist.trackList) { track in
                    PlayListRowView(
                        track: track,
                        onDelete: { trackToDelete in
                            deleteTrack(trackToDelete)
                        })
                    .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
                }
                .onMove(perform: moveTrack)
            }
            .listStyle(.plain)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    playlistUseCase.fetchPlaylistDetail(playlistId: Int(selectedPlaylist.id))
                    pathModel.pop()
                } label: {
                    Text("취소")
                        .foregroundStyle(.platPurple)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await playlistUseCase.updatePlaylist(
                            playlistId: Int(selectedPlaylist.id),
                            title: selectedPlaylist.title,
                            image: selectedImage
                        )
                        
                        playlistUseCase.fetchPlaylistDetail(playlistId: Int(selectedPlaylist.id))
                        pathModel.pop()
                    }
                } label: {
                    Text("완료")
                        .foregroundStyle(.platPurple)
                }
            }
        }
        .onAppear {
            selectedPlaylist = playlistUseCase.state.selectedPlaylist ?? Playlist(
                id: 0001,
                title: "플레이리스트 가져오기 실패",
                imageUrl: "",
                trackList: []
            )
        }
    }
    
    private func moveTrack(from source: IndexSet, to destination: Int) {
        selectedPlaylist.trackList.move(fromOffsets: source, toOffset: destination)
        playlistUseCase.updateTrackOrder(playlistId: Int(selectedPlaylist.id), tracks: selectedPlaylist.trackList)
    }
    
    private func deleteTrack(_ track: Track) {
        selectedPlaylist.trackList.removeAll { $0.id == track.id }
    }
}

// MARK: - PlayListEditInfo

private struct PlayListEditInfo: View {
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    @State private var isPhotoAlbumSheet = false
    @Binding private(set) var selectedImage: UIImage?
    @Binding private(set) var selectedPlaylist: Playlist
    
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
                    KFImage(URL(string: selectedPlaylist.imageUrl))
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
            
            TextField(" ", text: $selectedPlaylist.title)
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
                
                Text(selectedPlaylist.createdDate.yearMonthDayFormat)
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
    
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        Button {
            pathModel.presentSheet(.trackAppendSearch)
        } label: {
            HStack(spacing: 10) {
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray9)
                    .overlay {
                        Image(systemName: SystemImage.trackPlus)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.platPurple)
                    }
                    .padding(.leading, 18)
                
                Text("새로운 트랙 생성")
                    .font(.Body.body2)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
        }
        .padding(.trailing, 18)
        .padding(.bottom, 17)
    }
}

// MARK: - PlayListRowView

private struct PlayListRowView: View {
    
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var playlistMusic: Music?
    
    let track: Track
    let onDelete: (Track) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                Button {
                    Task {
                        await playlistUseCase.deleteTrackFromPlaylist(playlistId: Int(playlistUseCase.state.selectedPlaylistId ?? 0001), trackId: Int(track.id))
                        playlistUseCase.fetchPlaylistDetail(playlistId: Int(playlistUseCase.state.selectedPlaylistId ?? 0001))
                    }
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
                
                AlbumImageEdit(playlistMusic: $playlistMusic)
                    .padding(.horizontal, 10)
                
                TrackInfoEdit(playlistMusic: $playlistMusic, track: track)
                    .padding(.trailing, 40)
                
                Spacer()
                
                Image(systemName: SystemImage.trackDetail)
                    .foregroundColor(.gray9)
            }
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
            }
        }
        .padding(.vertical, 10)
    }
}

// MARK: - AlbumImageEdit

private struct AlbumImageEdit: View {
    
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

// MARK: - TrackInfoEdit

private struct TrackInfoEdit: View {
    
    @Binding private(set) var playlistMusic: Music?
    
    let track: Track
    
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
    PlaylistDetailsEditView()
        .injectDIContainer()
}
