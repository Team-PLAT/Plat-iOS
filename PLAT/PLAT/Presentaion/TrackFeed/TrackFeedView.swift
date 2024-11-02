//
//  TrackFeedView.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import SwiftUI

struct TrackFeedView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isLoading = false
    @State private var isNonePlaylistToastPresented = false
    
    /// 트랙 리스트를 반환합니다.
    private var trackList: [Track] {
        trackUseCase.feedTrackList.filter {
            let reportedTrackIdList = UserDefaults.standard.reportedTrackIdList
            return !reportedTrackIdList.contains($0.id)
        }
    }
    
    /// Feed를 업데이트합니다.
    private func updateFeed() {
        Task {
            await trackUseCase.fetchFeedTrackList(page: 0)
            let trackList = trackUseCase.feedTrackList
            
            let fetchMusicListResult = await musicControlUseCase.fetchMusicList(from: trackList)
            switch fetchMusicListResult {
            case .success(let musicList):
                trackUseCase.updateFeedTrackListMusicInfo(from: musicList)
                
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
    }
    
    /// MiniMusicPlayer를 탭합니다.
    private func miniMusicPlayerTapped(with trackId: Int) {
        Task {
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
                    
                case .failure(let error):
                    // TODO: 에러 처리
                    print(error)
                }
                
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
    }
    
    var body: some View {
        @Bindable var musicControlUseCase = musicControlUseCase
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    
                    Image(.imgFeedlogo)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
                
                ScrollView {
                    VStack {
                        ForEach(trackList) { track in
                            FeedRowView(
                                currentTrack: $musicControlUseCase.state.currentTrack,
                                isLoading: $isLoading,
                                isNonePlaylistToastPresented: $isNonePlaylistToastPresented,
                                track: track,
                                playlistId: ""
                            )
                        }
                    }
                }
                            
                if musicControlUseCase.state.isStreaming {
                    MiniMusicPlayer(
                        isPaused: $musicControlUseCase.state.isPaused,
                        track: $musicControlUseCase.state.currentTrack,
                        currentDuration: musicControlUseCase.state.currentDuration,
                        totalDuration: musicControlUseCase.state.currentTrack?.music.duration ?? 0
                    )
                    .onTapGesture {
                        if let selectedTrackId = musicControlUseCase.state.currentTrack?.id {
                            miniMusicPlayerTapped(with: Int(selectedTrackId))
                        }
                    }
                }
            }
            .background(.platBackground)
            
            VStack {
                Spacer()
                
                ToastMessage(
                    message: "트랙을 추가할 플레이리스트가 없어요.",
                    isToastPresented: $isNonePlaylistToastPresented
                )
                .padding(.bottom, 30)
            }
        }
        .overlay(
            PlatProgressView()
                .opacity(isLoading ? 1 : 0)
        )
        .onAppear {
            updateFeed()
        }
        .refreshable {
            // TODO: fetch 한 값 불러오기
        }
    }
}

// MARK: - FeedRowView

private struct FeedRowView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(AuthUseCase.self) private var authUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(PathModel.self) private var pathModel
    
    @State private var isPaused = true
    @State private var fetchMusicTask: Task<Void, Never>?
    
    @Binding private(set) var currentTrack: Track?
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    
    let track: Track
    let playlistId: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                FeedProfileImage(track: track)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        VStack(alignment: . leading, spacing: 2) {
                            FeedHeaderView(track: track)
                            FeedLocationView(track: track)
                        }
                        
                        Spacer()
                        
                        Menu {
                            if authUseCase.checkMyTrack(currentTrack: track) {
                                Button(role: .destructive) {
                                    trackUseCase.effect(.deleteTrack(trackId: Int(track.id)))
                                } label: {
                                    Text("삭제하기")
                                }
                            } else {
                                Button(role: .destructive) {
                                    pathModel.push(.report(trackId: track.id))
                                } label: {
                                    Text("신고하기")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.bottom, 8)
                        }
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
                    
                    FeedContentView(track: track)
                        .padding(.bottom, 8)
                    
                    FeedActionView(
                        track: track,
                        isNonePlaylistToastPresented: $isNonePlaylistToastPresented,
                        currentTrack: $musicControlUseCase.state.currentTrack,
                        isLoading: $isLoading
                    )
                    .padding(.bottom, 18)
                }
            }
            .padding(.top, 18)
            
            Rectangle()
                .foregroundColor(.gray9)
                .frame(width: UIScreen.main.bounds.width, height: 1)
        }
        .onAppear {
            authUseCase.effect(.fetchProfile)
        }
        .onDisappear {
            fetchMusicTask?.cancel()
            fetchMusicTask = nil
        }
    }
    
    //    /// 음악 Fetch에 딜레이를 부여합니다.
    //    private func handleFetchMusic() {
    //        fetchMusicTask = Task {
    //            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 딜레이
    //            if Task.isCancelled { return } // 만약 취소되었다면, Task 중단
    //            feedMusic =
    //            // feedMusic = await musicControlUseCase.fetchMusicInfoApi(music: track.music)
    //        }
    //    }
}

// MARK: - FeedProfileImage

private struct FeedProfileImage: View {
    
    let track: Track
    
    private var profileImageUrl: URL? {
        URL(string: track.user.profileImageUrl)
    }
    
    var body: some View {
        AsyncImage(url: profileImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray9)
            }
        }
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
    
    @Environment(MapUseCase.self) private var mapUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var address = ""
    
    let track: Track
    
    /// 역지오코딩을 이용해 주소를 업데이트합니다.
    private func updateAddress() {
        Task {
            let result = await mapUseCase.fetchReverGeocode(
                latitude: track.location.latitude,
                longitude: track.location.longitude
            )
            
            switch result {
            case .success(let place): address = place.address
            case .failure(let error): print(error) // TODO: 에러처리
            }
        }
    }
    
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
        .onAppear {
            updateAddress()
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
        AsyncImage(url: albumImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
            } else {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - FeedContentImage

private struct FeedContentImage: View {
    let track: Track
    
    var body: some View {
        if let imageUrl = track.imageUrl {
            if !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(Rectangle())
                            .cornerRadius(14)
                            .padding(.trailing, 18)
                    } else {
                        Rectangle()
                            .foregroundStyle(.gray9)
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(Rectangle())
                            .cornerRadius(14)
                            .padding(.trailing, 18)
                            .overlay(
                                PlatProgressView()
                            )
                    }
                }
            } else {
                EmptyView()
            }
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
    
    let track: Track
    
    @Binding private(set) var isNonePlaylistToastPresented: Bool
    @Binding private(set) var currentTrack: Track?
    @Binding private(set) var isLoading: Bool
    
    /// Feed를 업데이트합니다.
    private func updateFeed() {
        Task {
            await trackUseCase.fetchFeedTrackList(page: 0)
            let trackList = trackUseCase.feedTrackList
            
            let fetchMusicListResult = await musicControlUseCase.fetchMusicList(from: trackList)
            switch fetchMusicListResult {
            case .success(let musicList):
                trackUseCase.updateFeedTrackListMusicInfo(from: musicList)
                
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
    }
    
    /// 트랙의 좋아요를 업데이트합니다.
    private func likeTrack() {
        Task {
            isLoading = true
            let result = await trackUseCase.likeTrack(trackId: Int(track.id), isLike: track.isLike)
            switch result {
                
                // TODO: track을 눈속임 하는 것처럼 State로 관리해서 계속 Fetch 안할 수 있게 만들기
            case .success: updateFeed()
            case .failure(let error): print(error)
            }
            isLoading = false
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                likeTrack()
            } label: {
                Image(systemName: track.isLike ? SystemImage.like : SystemImage.unLike)
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
    }
}

// MARK: - Preview

#Preview {
    TrackFeedView()
        .environment(PreviewHelper.mockMusicControlUseCase)
        .injectDIContainer()
}
