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
    @State private var trackDetailUseCase: TrackDetailUseCase = .init(
        feedTrack: MockDataBuilder.feedTrack,
        track: MockDataBuilder.track,
        trackService: StubTrackService()
    )
    
    @State private var isContentSheetPresented = false
    
    init(track: Track) {
        self._trackDetailUseCase = State(
            initialValue: TrackDetailUseCase(
                feedTrack: [track],
                track: track,
                trackService: StubTrackService()
            )
        )
    }
    
    private var music: Music? {
        musicControlUseCase.state.music
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                MusicView()
                
                MusicControllerView()
                    .padding(.top, 24)
                
                // music?.duration ?? 0
                MusicSeekBar(
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: MockDataBuilder.music.duration
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
            musicControlUseCase.effect(.setup(music: MockDataBuilder.music))
        }
        .background(.black.opacity(0.6))
        .environment(trackDetailUseCase)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isContentSheetPresented = false
            }
        }
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
    
    //    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    private var music: Music? {
        //        trackDetailUseCase.track.music
        musicControlUseCase.state.music
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AlbumImage()
            
//            Text(music?.title ?? "제목업냐")
            Text(MockDataBuilder.music.title)
                .font(.Head.head2)
                .foregroundStyle(.white)
                .padding(.top, 16)
            
//            Text(music?.artist ?? "아티스트업냐")
            Text(MockDataBuilder.music.artist)
                .font(.Head.head5)
                .foregroundStyle(.gray7)
                .padding(.top, 4)
        }
    }
}

// MARK: - AlbumImage

private struct AlbumImage: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    private var albumImageUrl: URL? {
//        URL(string: musicControlUseCase.state.music?.albumImageUrl ?? "")
        URL(string: MockDataBuilder.music.albumImageUrl)
    }
    
    var body: some View {
        AsyncImage(url: albumImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - MusicControllerView

private struct MusicControllerView: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    var body: some View {
        HStack(spacing: 24) {
            MusicControllerCell(
                systemImage: "heart",
                tapAction: {
                    trackDetailUseCase.effect(.likeTrack)
                }
            )
            
            MusicControllerCell(
                systemImage: "text.badge.plus",
                tapAction: {
                    trackDetailUseCase.effect(.addToPlaylist)
                }
            )
            
            MusicControllerCell(
                systemImage: "repeat",
                tapAction: {
                    // TODO: 반복 재생
                }
            )
            
            MusicControllerCell(
                systemImage: "ellipsis.circle",
                tapAction: {
                    // TODO: 더보기 창 띄우기
                }
            )
        }
    }
}

// MARK: - MusicControllerCell

private struct MusicControllerCell: View {
    
    let systemImage: String
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.gray9)
                
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
            }
        }
    }
}

// MARK: - BottomView

private struct BottomView: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    @Binding private(set) var isContentSheetPresented: Bool
    
    private var content: String? {
        let origin = trackDetailUseCase.track.content
        if isContentSheetPresented {
            return origin
        } else {
            return String(origin?.prefix(10) ?? "") + "..."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let content = content {
                ProfileHeader()
                ProfileContent(
                    isContentSheetPresented: $isContentSheetPresented,
                    content: content
                )
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - ProfileHeader

private struct ProfileHeader: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    private var platter: Platter {
        trackDetailUseCase.track.platter
    }
    
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
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.gray9)
                }
            }
            
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
    
    @Binding private(set) var isContentSheetPresented: Bool
    
    let content: String
    
    var body: some View {
        HStack {
            Text(content)
                .font(.Body.body5)
                .foregroundStyle(.white)
            
            if !isContentSheetPresented {
                Button {
                    withAnimation(.easeInOut) {
                        isContentSheetPresented.toggle()
                    }
                } label: {
                    Text("더보기")
                        .font(.Body.body5)
                        .foregroundStyle(.platPurple)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Image(.imgTestBackground)
            .resizable()
            .scaledToFill()
            .frame(width: 0)
            .ignoresSafeArea()
        
        TrackDetailView(track: MockDataBuilder.track)
    }
}
