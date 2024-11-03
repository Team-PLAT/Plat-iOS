//
//  TrackFeedView.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import SwiftUI
import Kingfisher

struct TrackFeedView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MapUseCase.self) private var mapUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isLoading = false
    @State private var isNonePlaylistToastPresented = false
    
    var body: some View {
        @Bindable var musicControlUseCase = musicControlUseCase
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Image(.imgFeedlogo)
                    .padding(.leading, 20)
                    .padding(.vertical, 8)
                
                FeedList(
                    isNonePlaylistToastPresented: $isNonePlaylistToastPresented,
                    isLoading: $isLoading
                )
                
                if musicControlUseCase.state.isStreaming {
                    MiniMusicPlayer(
                        isPaused: $musicControlUseCase.state.isPaused,
                        track: $musicControlUseCase.state.currentTrack,
                        currentDuration: musicControlUseCase.state.currentDuration,
                        totalDuration: musicControlUseCase.state.currentTrack?.music.duration ?? 0
                    )
                    .onTapGesture(perform: miniMusicPlayerTapped)
                }
            }
            .background(.platBackground)
            
            ToastMessage(
                message: "트랙을 추가할 플레이리스트가 없어요.",
                isToastPresented: $isNonePlaylistToastPresented
            )
        }
        .overlay(PlatProgressView(isLoading: isLoading))
        .onDisappear(perform: trackUseCase.resetFeed)
    }
    
    /// MiniMusicPlayer를 탭합니다.
    private func miniMusicPlayerTapped() {
        if let selectedTrackId = musicControlUseCase.state.currentTrack?.id {
            Task {
                try await fetchSelectedTrack(with: Int(selectedTrackId))
            }
        }
    }
    
    /// 선택한 Track 정보를 Fetch합니다.
    private func fetchSelectedTrack(with trackId: Int) async throws {
        let updateCurrentTrackResult = await trackUseCase.fetchCurrentTrack(from: trackId)
        switch updateCurrentTrackResult {
        case .success(let fetchTrack):
            let musicResult = await musicControlUseCase.fetchMusic(from: fetchTrack)
            switch musicResult {
            case .success(let music):
                trackUseCase.updateCurrentTrackMusicInfo(from: music)
                let currentTrack = trackUseCase.currentTrack
                musicControlUseCase.updateCurrentTrack(to: currentTrack)
                pathModel.presentFullScreenCover(.trackDetail)
                
            case .failure(let error): throw error
            }
        case .failure(let error): throw error
        }
    }
}

// MARK: - FeedList

private struct FeedList: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    @Binding private(set) var isLoading: Bool
    
    /// 트랙 리스트를 반환합니다.
    private var trackList: [Track] {
        trackUseCase.feedTrackList.filter {
            let reportedTrackIdList = UserDefaults.standard.reportedTrackIdList
            return !reportedTrackIdList.contains($0.id)
        }
    }
    
    var body: some View {
        @Bindable var musicControlUseCase = musicControlUseCase
        ScrollView {
            LazyVStack {
                ForEach(Array(trackList.enumerated()), id: \.offset) { index, track in
                    FeedRow(
                        isLoading: $isLoading,
                        isNonePlaylistToastPresented: $isNonePlaylistToastPresented,
                        track: track,
                        address: track.location.place?.address ?? ""
                    )
                    .onAppear {
                        if index == trackList.count - 1 && trackUseCase.feedListHasNext {
                            fetchNextPage()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                let trackList = await trackUseCase.fetchFeedTrackList()
                try await updateFeed(from: trackList)
            }
        }
        .refreshable {
            trackUseCase.resetFeed()
            Task {
                let trackList = await trackUseCase.fetchFeedTrackList()
                try await updateFeed(from: trackList)
            }
        }
    }
    
    /// Feed를 업데이트합니다.
    private func updateFeed(from trackList: [Track]) async throws {
        let fetchMusicListResult = await musicControlUseCase.fetchMusicList(from: trackList)
        
        switch fetchMusicListResult {
        case .success(let musicList):
            trackUseCase.updateFeedTrackListMusicInfo(from: musicList)
            
        case .failure(let error):
            throw error
        }
    }
    
    /// 다음 페이지를 Fetch합니다.
    private func fetchNextPage() {
        Task {
            let trackList = await trackUseCase.paginationFeedTrackList()
            try await updateFeed(from: trackList)
        }
    }
}

// MARK: - FeedRow

private struct FeedRow: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(AuthUseCase.self) private var authUseCase
    
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    
    let track: Track
    let address: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                FeedProfileImage(track: track)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        VStack(alignment: . leading, spacing: 2) {
                            FeedHeaderView(track: track)
                            FeedLocationView(address: address, track: track)
                        }
                        
                        Spacer()
                        
                        MenuButton(isLoading: $isLoading, track: track)
                            .padding(.trailing, 18)
                    }
                    .padding(.bottom, 8)
                    
                    @Bindable var musicControlUseCase = musicControlUseCase
                    FeedPlayer(
                        isPaused: $musicControlUseCase.state.isPaused,
                        currentTrack: $musicControlUseCase.state.currentTrack,
                        track: track
                    )
                    .padding(.bottom, 6)
                    
                    FeedContentImage(track: track)
                        .padding(.bottom, 6)
                        .zIndex(-1)
                    
                    FeedContentView(track: track)
                        .padding(.bottom, 8)
                    
                    FeedActionView(
                        isNonePlaylistToastPresented: $isNonePlaylistToastPresented,
                        isLoading: $isLoading,
                        track: track
                    )
                    .padding(.bottom, 18)
                }
            }
            .padding(.top, 18)
            
            Sepeartor()
        }
    }
    
    private struct Sepeartor: View {
        var body: some View {
            Rectangle()
                .foregroundColor(.gray9)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
}

// MARK: - MenuButton

private struct MenuButton: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var isDeleteAlertPresented = false
    @State private var isDeleteCompletionAlertPresented = false
    @State private var deleteCompletionALertMessage = ""
    
    @Binding private(set) var isLoading: Bool
    
    let track: Track
    
    var body: some View {
        Menu {
            if authUseCase.checkMyTrack(currentTrack: track) {
                Button("삭제하기", role: .destructive) {
                    isDeleteAlertPresented.toggle()
                }
            } else {
                Button("신고하기", role: .destructive) {
                    pathModel.push(.report(trackId: track.id))
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .padding(.bottom, 8)
        }
        .alert("트랙을 삭제하시겠어요?", isPresented: $isDeleteAlertPresented) {
            AlertActionButton(variant: .cancel)
            AlertActionButton(variant: .confim) {
                Task {
                    isLoading = true
                    let result = await trackUseCase.deleteTrack(trackId: Int(track.id))
                    switch result {
                    case .success: deleteCompletionALertMessage = "트랙이 삭제되었습니다"
                    case .failure: deleteCompletionALertMessage = "일시적인 오류로 트랙 삭제에 실패했습니다"
                    }
                    isDeleteCompletionAlertPresented.toggle()
                    isLoading = false
                }
            }
        }
        .alert(deleteCompletionALertMessage, isPresented: $isDeleteCompletionAlertPresented) {
            AlertActionButton(variant: .confim)
        }
    }
}

// MARK: - FeedProfileImage

private struct FeedProfileImage: View {
    
    private let size: CGFloat = 40
    
    let track: Track
    
    private var profileImageUrl: URL? {
        URL(string: track.user.profileImageUrl)
    }
    
    var body: some View {
        KFImage(profileImageUrl)
            .placeholder {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundStyle(.gray9)
            }
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

// MARK: - FeedHeaderView

private struct FeedHeaderView: View {
    
    let track: Track
    
    var body: some View {
        HStack(spacing: 8) {
            Text(track.user.nickname)
                .font(.Body.body2)
                .foregroundStyle(.white)
            
            Circle()
                .frame(width: 2, height: 2)
            
            Text(track.createdDate.monthDayYearFormat)
                .font(.Body.body5)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - FeedLocationView

private struct FeedLocationView: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    
    let address: String
    
    let track: Track
    
    var body: some View {
        HStack(spacing: 4) {
            Image(.imgFeedloacation)
                .resizable()
                .scaledToFill()
                .frame(width: 12, height: 16)
            
            Text(address)
                .font(.Body.body5)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - FeedPlayer

private struct FeedPlayer: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding private(set) var isPaused: Bool
    @Binding private(set) var currentTrack: Track?
    
    let track: Track
    
    /// 재생 버튼을 탭했을 때 액션입니다.
    private func playButtonTapped() {
        print("현재 선택된 음악: \(track.music.title)")
        if currentTrack?.id == track.id {
            togglePlayBack()
        } else {
            startMusic()
            musicControlUseCase.updateCurrentTrack(to: track)
        }
    }
    
    /// 음악을 재생 / 일시정지 토글합니다.
    private func togglePlayBack() {
        musicControlUseCase.effect(.togglePlayback)
    }
    
    /// 음악을 처음 재생할 때입니다.
    private func startMusic() {
        Task {
            let result = await musicControlUseCase.startMusic(with: track.music.isrc)
            switch result {
            case .success: currentTrack?.id = track.id
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.platBlack)
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(.clear)
                    .background(
                        FeedAlbumImage(track: track)
                    )
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(track.music.title)
                        .font(.Body.body2)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text(track.music.artist)
                        .font(.Body.body4)
                        .foregroundStyle(.gray7)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    playButtonTapped()
                } label: {
                    Image(systemName: (currentTrack?.id == track.id && !isPaused) ? "pause.fill" : "play.fill")
                        .foregroundColor(.gray6)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 12)
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
            }
        }
        .padding(.trailing, 18)
    }
}

// MARK: - FeedAlbumImage

private struct FeedAlbumImage: View {
    
    let track: Track
    
    private var albumImageUrl: URL? {
        URL(string: track.music.albumImageUrl)
    }
    
    var body: some View {
        KFImage(albumImageUrl)
            .placeholder {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.gray9)
            }
            .resizable()
            .scaledToFill()
            .frame(width: 56, height: 56)
    }
}

// MARK: - FeedContentImage

private struct FeedContentImage: View {
    let track: Track
    
    var body: some View {
        if let imageUrl = track.imageUrl {
            if !imageUrl.isEmpty {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.gray9)
                    .aspectRatio(1, contentMode: .fill)
                    .overlay {
                        KFImage(URL(string: imageUrl))
                            .placeholder {
                                PlatProgressView(isLoading: true)
                            }
                            .cancelOnDisappear(true)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.trailing, 18)
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - FeedContentView

private struct FeedContentView: View {
    
    let track: Track
    
    @State private var isLimit: Bool?
    @State private var isExpended: Bool = false
    
    private var text: String? {
        track.content ?? ""
    }
    
    private func calculateLimit() -> some View {
        ViewThatFits(in: .vertical) {
            Text(text ?? "")
                .font(.Body.body5)
                .foregroundColor(.white)
                .hidden()
                .onAppear {
                    guard isLimit == nil else { return }
                    isLimit = false
                }
            
            Color.clear
                .hidden()
                .onAppear {
                    guard isLimit == nil else { return }
                    isLimit = true
                }
        }
    }
    
    var body: some View {
        if text != "" {
            HStack(spacing: 0) {
                if isExpended {
                    Text(text ?? "")
                        .font(.Body.body5)
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .background(calculateLimit())
                        .frame(width: 311, alignment: .leading)
                } else {
                    Text(text ?? "")
                        .font(.Body.body5)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .background(calculateLimit())
                        .frame(width: 276, alignment: .leading)
                    
                    if isLimit == true {
                        Text("더 보기")
                            .foregroundColor(.platPurple)
                            .font(.Body.body5)
                            .padding(.top, 20)
                            .onTapGesture {
                                self.isExpended.toggle()
                            }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - FeedActionView

private struct FeedActionView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PlaylistUseCase.self) private var playlistUseCase
    
    @State private var isLike = false
    
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    @Binding private(set) var isLoading: Bool
    
    let track: Track
    
    /// 트랙의 좋아요를 업데이트합니다.
    private func likeTrack() {
        Task {
            let result = await trackUseCase.likeTrack(trackId: Int(track.id), isLike: track.isLike)
            switch result {
            case let .success(bool): isLike = bool
            case let .failure(error): print(error)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                likeTrack()
            } label: {
                Image(systemName: isLike ? SystemImage.like : SystemImage.unLike)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 31)
            }
            
            Button {
                playlistUseCase.fetchPlaylists(completion: {})
                
                if playlistUseCase.state.playlists.isEmpty {
                    isNonePlaylistToastPresented.toggle()
                } else {
                    playlistUseCase.updateAppendTrackID(trackId: Int(track.id))
                    pathModel.presentSheet(.trackAppendToPlaylist)
                }
            } label: {
                Image(systemName: "text.badge.plus")
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 220)
            }
        }
        .task {
            isLike = track.isLike
        }
    }
}

// MARK: - Preview

#Preview {
    TrackFeedView()
        .environment(PreviewHelper.mockMusicControlUseCase)
        .injectDIContainer()
}
