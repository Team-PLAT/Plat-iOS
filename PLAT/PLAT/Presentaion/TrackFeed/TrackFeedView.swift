//
//  TrackFeedView.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import SwiftUI

struct TrackFeedView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var selectedTrackId: Int64?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Image(.imgFeedlogo)
                    .padding(.leading, 18)
                    .padding(.bottom, 20)
                
                ScrollView {
                    ForEach(MockDataBuilder.trackList) { track in
                        FeedRowView(
                            track: track,
                            trackIndex: Int64(track.id),
                            playlistId: "",
                            selectedTrackId: $selectedTrackId
                        )
                    }
                }
                
                if musicControlUseCase.state.isStreaming {
                    // TODO: 더미데이터 변경
                    @Bindable var musicControlUseCase = musicControlUseCase
                    MiniMusicPlayer(
                        isPaused: $musicControlUseCase.state.isPaused,
                        track: $musicControlUseCase.state.isPlayingTrack,
                        currentDuration: musicControlUseCase.state.currentDuration,
                        totalDuration: musicControlUseCase.state.music?.duration ?? 0
                    )
                }
            }
            .background(.platBackground)
        }
        .refreshable {
            // TODO: fetch 한 값 불러오기
        }
    }
}

// MARK: - FeedRowView

private struct FeedRowView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PathModel.self) private var pathModel
    
    let track: Track
    let trackIndex: Int64
    let playlistId: String
    
    @State private var feedMusic: Music?
    @Binding private(set) var selectedTrackId: Int64?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                FeedProfileImage(track: track)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        VStack(alignment: . leading, spacing: 2) {
                            FeedHeaderView(track: track)
                            FeedLocationView()
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button(role: .destructive) {
                                pathModel.push(.report(trackId: track.id))
                            } label: {
                                Text("신고하기")
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
                        trackIndex: Int64(trackIndex),
                        track: track,
                        isPaused: $musicControlUseCase.state.isPaused,
                        selectedTrackId: $selectedTrackId,
                        feedMusic: $feedMusic
                    )
                    .padding(.bottom, 6)
                    
                    FeedContentImage(track: track)
                        .padding(.bottom, 6)
                    
                    FeedContentView(track: track)
                        .padding(.bottom, 8)
                    
                    FeedActionView(trackIndex: Int(trackIndex), playlistId: playlistId)
                        .padding(.bottom, 18)
                }
            }
            .padding(.top, 18)
            
            Rectangle()
                .foregroundColor(.gray9)
                .frame(width: UIScreen.main.bounds.width, height: 1)
        }
        .onAppear {
            Task {
                feedMusic = await musicControlUseCase.fetchMusicInfoApi(music: track.music)
            }
        }
    }
}

// MARK: - FeedProfileImage

private struct FeedProfileImage: View {
    
    let track: Track
    
    private var user: User {
        track.user
    }
    
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
    
    private var user: User {
        track.user
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(user.nickname)
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
    
    var body: some View {
        HStack(spacing: 4) {
            Image(.imgFeedloacation)
                .resizable()
                .scaledToFill()
                .frame(width: 12, height: 16)
            
            // TODO: 주소 처리
            Text(trackUseCase.state.place.address)
                .font(.Body.body5)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - FeedPlayer

private struct FeedPlayer: View {
    
    var trackIndex: Int64?
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State var track: Track
    @Binding private(set) var isPaused: Bool
    @Binding private(set) var selectedTrackId: Int64?
    @Binding private(set) var feedMusic: Music?
    
    private var music: Music {
        feedMusic ?? Music(
            isrc: "",
            title: "",
            artist: "",
            albumImageUrl: "",
            duration: 0.0
        )
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.platBlack)
                .cornerRadius(8)
                .frame(width: 311, height: 56)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(.clear)
                    .background(
                        FeedAlbumImage(track: track,
                                       feedMusic: $feedMusic)
                    )
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(music.title)
                        .font(.Body.body2)
                        .foregroundStyle(.white)
                        .frame(width: 145, alignment: .leading)
                    
                    Text(music.artist)
                        .font(.Body.body4)
                        .foregroundStyle(.gray7)
                        .frame(width: 87, alignment: .leading)
                }
                .padding(.trailing, 70)
                
                Button {
                    /// 재생 정지 반복 토글
                    if selectedTrackId == trackIndex {
                        if let feedMusic {
                            track.music = feedMusic
                        }
                        musicControlUseCase.effect(.updatePlayingTrack(track: track))
                        musicControlUseCase.effect(.togglePlayback)
                    } else {
                        /// 처음 재생할 때
                        if let feedMusic {
                            track.music = feedMusic
                        }
                        musicControlUseCase.effect(.updatePlayingTrack(track: track))
                        musicControlUseCase.effect(.setup(music: track.music))
                        selectedTrackId = trackIndex
                    }
                } label: {
                    Image(systemName: (selectedTrackId == trackIndex && !isPaused) ? "pause.fill" : "play.fill")
                        .foregroundColor(.gray6)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 12)
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
            }
            .frame(width: 311, height: 56)
        }
    }
}

// MARK: - FeedAlbumImage

private struct FeedAlbumImage: View {
    
    let track: Track
    
    @Binding private(set) var feedMusic: Music?
    
    private var music: Music {
        feedMusic ?? Music(
            isrc: "",
            title: "",
            artist: "",
            albumImageUrl: "",
            duration: 0.0
        )
    }
    
    private var albumImageUrl: URL? {
        URL(string: feedMusic?.albumImageUrl ?? "")
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
    
    private var contentImageUrl: URL? {
        URL(string: track.imageUrl ?? "")
    }
    
    var body: some View {
        if contentImageUrl != nil {
            AsyncImage(url: contentImageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 311, height: 311)
                        .clipShape(Rectangle())
                        .cornerRadius(14)
                } else {
                    EmptyView()
                }
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
    
    let trackIndex: Int
    let playlistId: String
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var isLiked: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                isLiked.toggle()
                
                // TODO: 실제 데이터 넣기
                trackUseCase.effect(.likeTrack(trackId: 0, isLike: true))
            } label: {
                Image(systemName: isLiked ? "heart.fill" :  "suit.heart")
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 31)
            }
            
            Button {
                pathModel.presentSheet(.trackAppendToPlaylist)
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
