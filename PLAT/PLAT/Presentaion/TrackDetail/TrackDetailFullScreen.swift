//
//  TrackDetailFullScreen.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI
import Kingfisher

// MARK: - TrackDetailFullScreen

struct TrackDetailFullScreen: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isContentAreaPresented = false
    @State private var isNonePlaylistToastPresented = false
    @State private var isPlaying: Bool = true
    
    private var music: Music? {
        musicControlUseCase.state.currentTrack?.music
    }
    
    var body: some View {
        ZStack {
            Background()
            
            VStack(spacing: 0) {
                MusicView()
                
                MusicControllerView(isNonePlaylistToastPresented: $isNonePlaylistToastPresented)
                    .padding(.top, 24)
                
                MusicSeekBar(
                    totalDuration: music?.duration ?? 0
                )
                .padding(.top, 36)
                .padding(.horizontal, 16)
                
                MusicIndicator()
                    .padding(.top, 16)
            }
            
            VStack(spacing: 0) {
                HeaderView()
                    .padding(.leading, 16)
                
                Spacer()
                
                BottomView(isContentAreaPresented: $isContentAreaPresented)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 0)
            }
            
            VStack {
                Spacer()
                
                ToastMessage(
                    message: "트랙을 추가할 플레이리스트가 없어요.",
                    isToastPresented: $isNonePlaylistToastPresented
                )
            }
        }
        .background(.black.opacity(0.6))
        .presentationBackground(.thinMaterial.opacity(0.5))
        .onTapGesture {
            withAnimation(.easeInOut) {
                isContentAreaPresented = false
            }
        }
    }
}

// MARK: - Background

private struct Background: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    
    var body: some View {
        Group {
            if let imageString = trackUseCase.currentTrack.imageUrl,
               let imageURL = URL(string: imageString) {
                KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 0)
            }
            
            Color.black.opacity(0.6)
        }
        .ignoresSafeArea()
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MapUseCase.self) private var mapUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    /// Feed를 업데이트합니다.
    private func updateFeed() {
        Task {
            await trackUseCase.fetchFeedTrackList(page: 0)
            let trackList = trackUseCase.feedTrackList
            
            let fetchMusicListResult = await musicControlUseCase.fetchMusicList(from: trackList)
            switch fetchMusicListResult {
            case .success(let musicList):
                trackUseCase.updateFeedTrackListMusicInfo(from: musicList)
                pathModel.dismissFullScreenCover()
                
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(.imgMarker)
            
            if let place = mapUseCase.state.place {
                Text(place.address)
                    .font(.Head.head2)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            DismissButton {
                updateFeed()
            }
        }
    }
}

// MARK: - MusicView

private struct MusicView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    private var music: Music? {
        musicControlUseCase.state.currentTrack?.music
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AlbumImage()
            
            Text(music?.title ?? "")
                .font(.Head.head2)
                .foregroundStyle(.white)
                .padding(.top, 16)
            
            Text(music?.artist ?? "")
                .font(.Head.head5)
                .foregroundStyle(.gray7)
                .padding(.top, 4)
        }
    }
}

// MARK: - AlbumImage

private struct AlbumImage: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    private let imageSize: CGFloat = 200
    private let cornerRaduis: CGFloat = 12
    
    private var albumImageUrl: URL? {
        URL(string: musicControlUseCase.state.currentTrack?.music.albumImageUrl ?? "")
    }
    
    var body: some View {
        KFImage(albumImageUrl)
            .placeholder {
                RoundedRectangle(cornerRadius: cornerRaduis)
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(.gray9)
            }
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: cornerRaduis))
    }
}

// MARK: - MusicControllerView

private struct MusicControllerView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isTrackAppendToPlaylistSheetPresented = false
    
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    
    private var isLiked: Bool {
        trackUseCase.currentTrack.isLike
    }
    
    /// 트랙의 좋아요를 업데이트합니다.
    private func likeTrack() {
        var track = trackUseCase.currentTrack
        
        Task {
            let result = await trackUseCase.likeTrack(
                trackId: Int(track.id),
                isLike: track.isLike
            )
            
            switch result {
            case .success(let isLike):
                track.isLike = isLike
                trackUseCase.updateCurrentTrack(to: track)
                
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 52) {
            MusicControllerCell(
                systemImage: isLiked ? SystemImage.like : SystemImage.unLike,
                tapAction: {
                    likeTrack()
                }
            )
            
            MusicControllerCell(
                systemImage: SystemImage.addToPlaylist,
                tapAction: {
                    if playlistUseCase.state.playlists.isEmpty {
                        isNonePlaylistToastPresented.toggle()
                    } else {
                        isTrackAppendToPlaylistSheetPresented.toggle()
                    }
                }
            )
            
            Menu {
                if userUseCase.checkMyTrack(currentTrack: trackUseCase.currentTrack) {
                    Button(role: .destructive) {
                        trackUseCase.effect(.deleteTrack(trackId: Int(trackUseCase.currentTrack.id)))
                    } label: {
                        Text("삭제하기")
                    }
                } else {
                    Button(role: .destructive) {
                        pathModel.dismissFullScreenCover()
                        pathModel.push(.report(trackId: trackUseCase.currentTrack.id))
                    } label: {
                        Text("신고하기")
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.gray9)
                    
                    Image(systemName: SystemImage.seeMore)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $isTrackAppendToPlaylistSheetPresented) {
            TrackAppendToPlaylistSheet()
        }
    }
}

// MARK: - MusicControllerCell

private struct MusicControllerCell: View {
    
    let systemImage: String
    let tapAction: () -> Void
    
    private let backCircleSize: CGFloat = 36
    private let systemImageSize: CGFloat = 16
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            ZStack {
                Circle()
                    .frame(width: backCircleSize, height: backCircleSize)
                    .foregroundStyle(.gray9)
                
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: systemImageSize, height: systemImageSize)
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - BottomView

private struct BottomView: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @Binding private(set) var isContentAreaPresented: Bool
    
    /// 현재 Track의 Content를 반환합니다.
    private var content: String? {
        let origin = trackUseCase.currentTrack.content
        if isContentAreaPresented {
            return origin
        } else {
            if let safeOrigin = origin {
                let contentLimit = Constant.trackContentSeeMoreButtonLimit
                return trimContentWithDot(safeOrigin, size: contentLimit)
            } else {
                return nil
            }
        }
    }
    
    /// 문자열을 주어진 글자수에 맞게 잘라낸 후 ...을 붙여 반환합니다.
    func trimContentWithDot(_ content: String, size: Int) -> String {
        return String(content.prefix(size)) + "..."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileHeader()
            
            if let content = content {
                ProfileContent(
                    isContentSheetPresented: $isContentAreaPresented,
                    content: content
                )
            }
        }
    }
}

// MARK: - ProfileHeader

private struct ProfileHeader: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    
    /// 프로필 이미지 사이즈
    private let profileImageSize: CGFloat = 40
    
    /// 현재 Track을 업로드한 User를 반환합니다.
    private var user: User {
        trackUseCase.currentTrack.user
    }
    
    /// 프로필 이미지 URL을 반환합니다.
    private var profileImageUrl: URL? {
        let urlString = user.profileImageUrl
        return URL(string: urlString)
    }
    
    var body: some View {
        HStack(spacing: 6) {
            KFImage(profileImageUrl)
                .placeholder {
                    Circle()
                        .foregroundStyle(.gray9)
                }
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: profileImageSize, height: profileImageSize)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(user.nickname)
                    .font(.Body.body2)
                
                Text(trackUseCase.currentTrack.createdDate.yearMonthDayFormat)
                    .font(.Body.body5)
            }
            .foregroundStyle(.white)
            
            Spacer()
        }
    }
}

// MARK: - ProfileContent

private struct ProfileContent: View {
    
    @Binding private(set) var isContentSheetPresented: Bool
    
    let content: String
    
    /// 더보기 버튼이 보이는 분기를 계산합니다.
    private var isSeeMoreButtonVisible: Bool {
        let isContentCountLimit = content.count >= Constant.trackContentSeeMoreButtonLimit
        return !isContentSheetPresented && isContentCountLimit
    }
    
    var body: some View {
        HStack {
            Text(content)
                .font(.Body.body5)
                .foregroundStyle(.white)
            
            if isSeeMoreButtonVisible {
                Button("더보기") {
                    withAnimation(.easeInOut) {
                        isContentSheetPresented.toggle()
                    }
                }
                .font(.Body.body5)
                .foregroundStyle(.platPurple)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrackDetailFullScreen()
        .environment(PreviewHelper.mockMusicControlUseCase)
        .injectDIContainer()
}
