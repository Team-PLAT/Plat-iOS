//
//  PlatProcessingFullScreen.swift
//  PLAT
//
//  Created by 박준우 on 8/18/24.
//

import SwiftUI

// MARK: - PlatProcessingFullScreen

struct PlatProcessingFullScreen: View {
    @State var isCompleteLoading = false
    
    var body: some View {
        VStack {
            PlatProcessingDismissButton()
            
            Spacer()
            
            if isCompleteLoading {
                PlatProcessingPlaylist()
            } else {
                PlatProcessingLoading()
            }
        }
        .presentationBackground(.black.opacity(0.8))
        
        // TODO: 로딩뷰에서 플레이리스트뷰로 넘어가는 로직 기획 나오면 구현하기
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
    
    var body: some View {
        VStack(spacing: 0) {
            
            PlatProcessingPlaylistInfo()
                .padding(.bottom, 10)
            
            PlatProcessingPlaylistButton()
                .padding(.bottom, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(trackUseCase.mapTrackList) { track in
                        PlatProcessingPlaylistRow(track: track)
                    }
                }
            }
        }
    }
}

// MARK: - PlatProcessingPlaylistInfo

private struct PlatProcessingPlaylistInfo: View {
    @Environment(MapUseCase.self) private var mapUseCase
    @Environment(UserUseCase.self) private var trackUseCase
    
    @State private var locationManager = MapKitLocationServiceImpl()
    @State private var addressName: String = ""
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 220, height: 220)
                .foregroundStyle(LinearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                .padding(.bottom, 16)
            
            Text("\(addressName)에서의 PLAT")
                .font(.Head.head2)
                .foregroundStyle(.white)
                .frame(width: 213, height: 44, alignment: .center)
                .padding(.bottom, -12)
            
            Text(Date().yearMonthDayFormat)
                .font(.Body.body1)
                .foregroundStyle(.gray7)
                .frame(width: 160, height: 44, alignment: .center)
            
        }
        .onAppear {
            Task {
                if let coordinate = locationManager.location?.coordinate {
                    let result = await mapUseCase.fetchReverGeocode(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    switch result {
                    case .success(let success):
                        addressName = success.address
                    case .failure(let failure):
                        break
                    }
                } else {
                    print("PlatProcessing 주소 데이터 오류")
                }
            }
        }
    }
}

// MARK: - PlatProcessingPlaylistButton

private struct PlatProcessingPlaylistButton: View {
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @State private var isrcs: [String] = []
    
    var body: some View {
        HStack(spacing: 27) {
            Button {
                // TODO: 미니 플레이어 연결하기
                musicControlUseCase.effect(.playPlaylist(isrcs: isrcs))
                pathModel.dismissFullScreenCover()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.play)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white)
                            
                            Text("재생")
                                .font(.Body.body2)
                                .foregroundStyle(.white)
                        }
                    }
            }
            
            Button {
                // TODO: 저장 기능 구현(API 미구현)
                pathModel.dismissFullScreenCover()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(.imgPlaylistsave)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white)
                            
                            Text("플레이리스트 저장")
                                .font(.Body.body2)
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .onAppear {
            isrcs = trackUseCase.mapTrackList.map { track in
                return track.music.isrc
            }
        }
    }
}

// MARK: - PlatProcessingPlaylistRow

private struct PlatProcessingPlaylistRow: View {
    private(set) var track: Track
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PlatProcessingPlaylistRowImage(music: track.music)
                    .padding(.trailing, 10)
                    .padding(.leading, 18)
                
                PlatProcessingPlaylistRowInfo(track: track)
                    .padding(.trailing, 40)
                
                Spacer()
            }
            .padding(.vertical, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
                .padding(.leading, 46)
        }
    }
}

// MARK: - PlatProcessingPlaylistRowImage

private struct PlatProcessingPlaylistRowImage: View {
    private(set) var music: Music
    
    var body: some View {
        AsyncImage(url: URL(string: music.albumImageUrl)) { phase in
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

// MARK: - PlatProcessingPlaylistRowInfo

private struct PlatProcessingPlaylistRowInfo: View {
    @Environment(UserUseCase.self) private var userUseCase
    
    private(set) var track: Track
    
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
                
                if track.user.id == userUseCase.state.user.id {
                    Text("직접 추가됨")
                        .font(.Body.body5)
                        .foregroundStyle(.gray7)
                } else {
                    Text("\(track.user.nickname)의 트랙")
                        .font(.Body.body5)
                        .foregroundStyle(.gray7)
                }
            }
        }
    }
}

#Preview {
    PlatProcessingFullScreen()
        .injectDIContainer()
}
