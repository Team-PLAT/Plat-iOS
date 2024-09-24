//
//  PlatProcessingFullScreen.swift
//  PLAT
//
//  Created by 박준우 on 8/18/24.
//

import SwiftUI

// MARK: - PlatProcessingFullScreen

struct PlatProcessingFullScreen: View {
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var isCompleteLoading = false
    
    var body: some View {
        VStack {
            PlatProcessingDismissButton()
            
            Spacer()
            
            if isCompleteLoading {
                if trackUseCase.mapTrackList.isEmpty {
                    Text("No playlist available")
                } else {
                    PlatProcessingPlaylist()
                }
            } else {
                if trackUseCase.mapTrackList.isEmpty {
                    Text("Loading failed")
                } else {
                    PlatProcessingLoading()
                }
            }
        }
        .presentationBackground(.black.opacity(0.8))
        
        // TODO: PlatProcessing 로딩뷰에서 PlatProcessing 플레이리스트뷰로 넘어가는 로직 기획 나오면 구현하기
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                isCompleteLoading = true
            }
        }
    }
}

// MARK: - PlatProcessingDismissButton

private struct PlatProcessingDismissButton: View {
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        HStack {
            Spacer()
            
            DismissButton {
                pathModel.dismissFullScreenCover()
            }
        }
    }
}

// MARK: - PlatProcessingLoading

private struct PlatProcessingLoading: View {
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var timer: Timer?
    @State private var dotTextCount: Int = 0
    @State private var trackRandomIndex: Int = 0
    
    var body: some View {
        VStack {
            // TODO: PlatProcessing 로딩 화면 기획 나오면 구현하기
            Spacer()
            
            Group {
                if let imgUrl = trackUseCase.mapTrackList[trackRandomIndex].imageUrl {
                    AsyncImage(url: URL(string: imgUrl)) { img in
                        if let image = img.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                        }
                    }
                } else {
                    Circle()
                        .fill(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                }
            }
            .frame(width: 100, height: 100)
            
            Spacer()
            
            Text("Platting\(String(repeating: ".", count: dotTextCount))")
                .font(.Head.head3)
                .padding(.bottom, 104)
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                dotTextCount = (dotTextCount + 1) % (4 + 1)
                trackRandomIndex = Int.random(in: 0...(trackUseCase.mapTrackList.count - 1))
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

// MARK: - PlatProcessingPlaylist

private struct PlatProcessingPlaylist: View {
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MapUseCase.self) private var mapUseCase
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 86)
                .padding(.bottom)
            
            // TODO: 역지오코딩 기능 연결
            Text("\("지곡동")에서의 PLAT")
                .font(.Head.head2)
                .padding(.bottom, 4)
            
            Text(Date().yearMonthDayFormat)
                .font(.Body.body1)
                .foregroundStyle(.gray7)
                .padding(.bottom)
            
            PlatProcessingPlaylistButton()
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray9)
                .padding(.top, 40)
            
            PlatProcessingPlaylistTracklist()
        }
    }
}

// MARK: - PlatProcessingPlaylistButton

private struct PlatProcessingPlaylistButton: View {
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        HStack(spacing: 26) {
            Group {
                Button {
                    // TODO: 플레이리스트 재생 기능 추가
                    pathModel.dismissFullScreenCover()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray9)
                        .overlay {
                            HStack(spacing: 4) {
                                Image(systemName: SystemImage.play)
                                
                                Text("재생")
                            }
                        }
                }
                
                Button {
                    // TODO: 플레이리스트 저장 기능 추가
                    pathModel.dismissFullScreenCover()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray9)
                        .overlay {
                            HStack(spacing: 4) {
                                Image("img_playlistsave")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(.vertical, 14)
                                
                                Text("플레이리스트 저장")
                            }
                        }
                }
            }
            .frame(height: 44)
            .font(.Body.body2)
        }
        .padding(.horizontal, 18)
    }
}

// MARK: - PlatProcessingPlaylistTracklist

private struct PlatProcessingPlaylistTracklist: View {
    @Environment(TrackUseCase.self) private var trackUseCase
    
    var body: some View {
        List(trackUseCase.mapTrackList) { track in
            VStack(alignment: .leading) {
                HStack {
                    // TODO: 음원 이미지가 없을 때 기본 이미지 설정하기
                    if let imgUrl = track.imageUrl {
                        AsyncImage(url: URL(string: imgUrl)) { img in
                            if let image = img.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 40, height: 40)
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                            .frame(width: 40, height: 40)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(track.music.title)")
                            .font(.Body.body3)
                        
                        Text("\(track.music.artist)・ \(track.user.nickname)의 트랙")
                            .font(.Body.body5)
                            .foregroundStyle(.gray7)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparatorTint(.gray9)
            .listRowInsets(EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 0))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    PlatProcessingFullScreen(playList: .constant(MockDataBuilder.playlist))
}
