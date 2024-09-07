//
//  TrackDetailView.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - TrackDetailView

struct TrackDetailView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    // TODO: 이후 상위에서 주입 받기
    // TODO: Stub 객체 교체하기
    @State private var trackDetailUseCase: TrackDetailUseCase
    
    @State private var isContentSheetPresented = false
    
    init(trackId: Track.ID) {
        self.trackDetailUseCase = TrackDetailUseCase(
            feedTrack: MockDataBuilder.feedTrack,
            track: MockDataBuilder.feedTrack.randomElement() ?? MockDataBuilder.track,
            trackService: StubTrackService(),
            trackId: trackId
        )
    }
    
    private var music: Music? {
        musicControlUseCase.state.music
    }
    
    var body: some View {
        ZStack {
            Background()
            
            VStack(spacing: 0) {
                MusicView()
                
                MusicControllerView()
                    .padding(.top, 24)
                
                MusicSeekBar(
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: musicControlUseCase.state.music?.duration ?? 0
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
                
                BottomView(isContentSheetPresented: $isContentSheetPresented)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 0)
            }
        }
        .onAppear {
            Task {
                let currentTrackId = trackDetailUseCase.trackId
                
                if let track = MockDataBuilder.trackList.first(where: { $0.id == currentTrackId }) {
                    await musicControlUseCase.effect(.setup(music: track.music))
                } else {
                    print("trackId 찾기 오류 \(currentTrackId)")
                }
            }
        }
        .background(.black.opacity(0.6))
        .presentationBackground(.thinMaterial.opacity(0.5))
        .environment(trackDetailUseCase)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isContentSheetPresented = false
            }
        }
    }
}

// MARK: - Background

private struct Background: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    var body: some View {
        Group {
            // TODO: 만약 Track에 이미지가 있다면 다른 이미지로 처리하기
            if let imageString = trackDetailUseCase.track.imageUrl,
               let imageURL = URL(string: imageString) {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 0)
                    }
                }
            }
            
            Color.black.opacity(0.6)
        }
        .ignoresSafeArea()
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    var body: some View {
        VStack(alignment: .leading, spacing: -2) {
            HStack {
                Image(.imgMarker)
                
                Group {
                    if let placeName = trackDetailUseCase.state.place.name {
                        Text(placeName)
                        
                    } else {
                        Text(trackDetailUseCase.state.place.address)
                    }
                }
                .font(.Head.head2)
                .foregroundStyle(.white)
                
                Spacer()
                
                DismissButton {
                    dismiss()
                }
            }
            
            Text(trackDetailUseCase.state.place.address)
                .font(.Body.body3)
                .foregroundStyle(.white)
                .padding(.leading, 24)
        }
    }
}

// MARK: - MusicView

private struct MusicView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    private var music: Music? {
        musicControlUseCase.state.music
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
        URL(string: musicControlUseCase.state.music?.albumImageUrl ?? "")
    }
    
    var body: some View {
        AsyncImage(url: albumImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRaduis))
            } else {
                RoundedRectangle(cornerRadius: cornerRaduis)
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - MusicControllerView

private struct MusicControllerView: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isTrackAppendToPlaylistSheetPresented = false
    
    var body: some View {
        HStack(spacing: 24) {
            MusicControllerCell(
                systemImage: SystemImage.like,
                tapAction: {
                    trackDetailUseCase.effect(.likeTrack)
                }
            )
            
            MusicControllerCell(
                systemImage: SystemImage.addToPlaylist,
                tapAction: {
                    isTrackAppendToPlaylistSheetPresented.toggle()
                }
            )
            
            MusicControllerCell(
                systemImage: SystemImage.postWithThisMusic,
                tapAction: {
                    // TODO: 이 음악으로 내가 게시하기(추후 개발)
                }
            )
            
            MusicControllerCell(
                systemImage: SystemImage.seeMore,
                tapAction: {
                    // TODO: 더보기 창 띄우기
                }
            )
        }
        .sheet(isPresented: $isTrackAppendToPlaylistSheetPresented) {
            TrackAppendToPlaylistSheet()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(286)])
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
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    @Binding private(set) var isContentSheetPresented: Bool
    
    /// 현재 Track의 Content를 반환합니다.
    private var content: String? {
        let origin = trackDetailUseCase.track.content
        if isContentSheetPresented {
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
                    isContentSheetPresented: $isContentSheetPresented,
                    content: content
                )
            }
        }
    }
}

// MARK: - ProfileHeader

private struct ProfileHeader: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    /// 프로필 이미지 사이즈
    private let profileImageSize: CGFloat = 40
    
    /// 현재 Track을 업로드한 Platter를 반환합니다.
    private var platter: Platter {
        trackDetailUseCase.track.platter
    }
    
    /// 프로필 이미지 URL을 반환합니다.
    private var profileImageUrl: URL? {
        let urlString = platter.profileImageUrl
        return URL(string: urlString)
    }
    
    var body: some View {
        HStack(spacing: 6) {
            AsyncImage(url: profileImageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundStyle(.gray9)
                }
            }
            .frame(width: profileImageSize, height: profileImageSize)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(platter.nickname)
                    .font(.Body.body2)
                
                Text(trackDetailUseCase.track.createdDate.yearMonthDayFormat)
                    .font(.Body.body5)
            }
            .foregroundStyle(.white)
            
            Spacer()
        }
    }
}

// MARK: - ProfileContent

private struct ProfileContent: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
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
    TrackDetailView(trackId: .init())
        .environment(PreviewHelper.mockMusicControlUseCase)
}
