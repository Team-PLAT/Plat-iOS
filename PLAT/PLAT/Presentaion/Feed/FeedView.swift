//
//  FeedView.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import SwiftUI

struct FeedView: View {
    
    @State private var trackUseCase: TrackUseCase = .init(
        feedTrack: MockDataBuilder.feedTrack,
        detailTrack: MockDataBuilder.track,
        trackService: StubTrackService()
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.imgFeedlogo)
                .padding(.leading, 18)
                .padding(.bottom, 20)
            ScrollView {
                ForEach(MockDataBuilder.feedTrack) { track in
                    FeedRowView(track: track)
                }
            }
        }
        .environment(trackUseCase)
        .refreshable {
            // TODO: fetch 한 값 불러오기
        }
    }
}

// MARK: - FeedRowView

private struct FeedRowView: View {
    
    let track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                FeedProfileImage(track: track)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        VStack(alignment: . leading, spacing: 2) {
                            FeedHeaderView(track: track)
                            FeedLocationView()
                        }
                        .padding(.trailing, 96)
                        
                        Button {
                            // 신고 알럿 창 띄우기
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    FeedPlayer(track: track)
                        .padding(.bottom, 6)
                    
                    FeedContentImage(track: track)
                        .padding(.bottom, 6)
                    
                    FeedContentView(track: track)
                        .padding(.bottom, 8)
                    
                    FeedActionView()
                        .padding(.bottom, 18)
                }
            }
            .padding(.top, 18)
            
            Rectangle()
                .foregroundColor(.gray9)
                .frame(width: UIScreen.main.bounds.width, height: 1)
        }
    }
}

// MARK: - FeedProfileImage

private struct FeedProfileImage: View {
    
    let track: Track
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    private var platter: Platter {
        track.platter
        //        trackDetailUseCase.track.platter
    }
    
    private var profileImageUrl: URL? {
//                URL(string: trackDetailUseCase.track.platter.profileImageUrl)
        URL(string: track.platter.profileImageUrl)
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
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    private var platter: Platter {
        //        trackDetailUseCase.track.platter
        track.platter
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(platter.nickname)
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
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    var body: some View {
        HStack(spacing: 4) {
            Image(.imgFeedloacation)
                .resizable()
                .scaledToFill()
                .frame(width: 12, height: 16)
            
            // TODO: 대한민국 경상북도 제거 후 변경
            Text(trackDetailUseCase.state.place.address)
                .font(.Body.body5)
                .foregroundStyle(.white)
            
        }
    }
}

// MARK: - FeedPlayer

private struct FeedPlayer: View {
    
    let track: Track
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    private var music: Music {
        //        trackDetailUseCase.track.music
        track.music
    }
    
    private var isPaused: Bool {
        trackDetailUseCase.state.isPaused
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
                        FeedAlbumImage(track: track)
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
                    // TODO: MusicControlUseCase 재생 토글
                } label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .foregroundColor(.gray6)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 12)
                }
            }
            .frame(width: 311, height: 56)
        }
    }
}

// MARK: - FeedAlbumImage

private struct FeedAlbumImage: View {
    
    let track: Track
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    private var albumImageUrl: URL? {
        //        URL(string: trackDetailUseCase.track.music.albumImageUrl)
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
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    private var contentImageUrl: URL? {
        //        URL(string: trackDetailUseCase.track.imageUrl ?? "")
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
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    @State private var isLimit: Bool?
    @State private var isExpended: Bool = false
    
    private var text: String? {
        //        trackDetailUseCase.track.content ?? ""
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
    
    @Environment(TrackUseCase.self) private var trackDetailUseCase
    
    @State private var isLiked: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                isLiked.toggle()
                trackDetailUseCase.effect(.likeTrack)
            } label: {
                Image(systemName: isLiked ? "heart.fill" :  "suit.heart")
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 31)
            }
            
            Button {
                trackDetailUseCase.effect(.addToPlaylist)
            } label: {
                Image(systemName: "text.badge.plus")
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 220)
            }
            
            Button {
                // TODO: MusicControlUseCase 다시 재생(근데 얘는 없어져야함)
            } label: {
                Image(systemName: "repeat")
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 18)
            }
        }
    }
}

#Preview {
    FeedView()
}
