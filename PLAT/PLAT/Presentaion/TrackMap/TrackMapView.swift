//
//  TrackMapView.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import SwiftUI
import MapKit

// MARK: - TrackMapView

struct TrackMapView: View {
    
    @Environment(MapUseCase.self) private var mapUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(MapKitLocationServiceImpl.self) private var locationManager
    
    @State private var hasNotifications = false
    @State private var isShowToastMessage: Bool = false
    
    private func updateMap(with location: CLLocation) {
        
        // 1. 역지오코딩 API 호출
        mapUseCase.updateReverseGeocode(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        // 2. 현재 좌표에 기반한 Track 받아오기
        Task {
            let rectLocation = locationManager.calculateRectCoordinates(from: location)
            await trackUseCase.fetchMapTrackLst(rectLocation: rectLocation)
            let trackList = trackUseCase.mapTrackList
            
            let fetchMusicListResult = await musicControlUseCase.fetchMusicList(from: trackList)
            switch fetchMusicListResult {
            case .success(let musicList):
                trackUseCase.updateMapTrackListMusicInfo(from: musicList)
                
            case .failure(let error):
                // TODO: 에러 처리
                print(error)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topLeading) {
                if #available(iOS 18.0, *) {
                    MapView()
                        .toolbarVisibility(.hidden, for: .navigationBar)
                } else {
                    MapView()
                }
                
                MapComponentsView(
                    hasNotifications: $hasNotifications,
                    isShowToastMessage: $isShowToastMessage
                )
            }
            
            ToastMessage(
                message: "플레이리스트를 생성할 트랙이 없어요",
                isToastPresented: $isShowToastMessage
            )
        }
        .onReceive(locationManager.locationPublisher) { location in
            updateMap(with: location)
        }
    }
}

// MARK: - MapView

private struct MapView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(MapKitLocationServiceImpl.self) private var locationManager
    
    @State private var fetchMusicTask: Task<Void, Never>?
    
    /// 신고된 트랙 리스트를 필터 후 반환합니다.
    private var trackList: [Track] {
        trackUseCase.mapTrackList.filter {
            let reportedTrackIdList = UserDefaults.standard.reportedTrackIdList
            return !reportedTrackIdList.contains($0.id)
        }
    }
    
    /// 트랙 좌표를 반환합니다.
    private func coordinate(_ location: Location) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    /// 마커를 탭합니다.
    private func customMarkerTapped(with trackId: Int) {
        Task {
            let updateCurrentTrackResult = await trackUseCase.fetchCurrentTrack(from: trackId)
            switch updateCurrentTrackResult {
            case .success(let fetchTrack):
                musicControlUseCase.updateCurrentTrack(to: fetchTrack)
                
                let startMusicResult = await musicControlUseCase.startMusic(with: fetchTrack.music.isrc)
                
                switch startMusicResult {
                case .success:
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
        @Bindable var locationManager = locationManager
        
        Map(position: $locationManager.position, interactionModes: []) {
            UserAnnotation()
            
            ForEach(trackList) { track in
                Annotation("", coordinate: coordinate(track.location)) {
                    CustomMarkerView(track: track)
                        .onTapGesture {
                            customMarkerTapped(with: Int(track.id))
                        }
                }
            }
            
            if let location = locationManager.location {
                MapCircle(
                    center: location.coordinate,
                    radius: CLLocationDistance(500)
                )
                .foregroundStyle(.platDarkpurple.opacity(0.5))
            }
        }
        .onAppear {
            handleFetchMusic()
        }
        .onDisappear {
            fetchMusicTask?.cancel()
            fetchMusicTask = nil
        }
    }
    
    /// 음악 Fetch에 딜레이를 부여합니다.
    private func handleFetchMusic() {
        fetchMusicTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 딜레이
            if Task.isCancelled { return } // 만약 취소되었다면, Task 중단
            if let music = musicControlUseCase.state.currentTrack?.music {
                // playlistMusic = await musicControlUseCase.fetchMusicInfoApi(music: music)
            }
        }
    }
}

// MARK: - CustomMarkerView

private struct CustomMarkerView: View {
    
    let track: Track
    
    var body: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.gray3)
            .overlay {
                AsyncImage(url: URL(string: track.music.albumImageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 34, height: 34)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray3)
                    }
                }
                
            }
    }
}

// MARK: - MapComponentsView

private struct MapComponentsView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding var hasNotifications: Bool
    @Binding var isShowToastMessage: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                MapAddressView()
                Spacer()
                MapButtonsView(
                    isShowToastMessage: $isShowToastMessage,
                    hasNotifications: $hasNotifications
                )
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 18)
            
            if musicControlUseCase.state.isStreaming {
                @Bindable var musicControlUseCase = musicControlUseCase
                MiniMusicPlayer(
                    isPaused: $musicControlUseCase.state.isPaused,
                    track: $musicControlUseCase.state.currentTrack,
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: musicControlUseCase.state.currentTrack?.music.duration ?? 0
                )
                .onTapGesture {
                    pathModel.presentFullScreenCover(.trackDetail)
                }
            }
        }
    }
}

// MARK: - MapAddressView

private struct MapAddressView: View {
    
    @Environment(MapUseCase.self) private var mapUseCase
    
    var body: some View {
        HStack {
            Image(.imgMarker)
            
            if let place = mapUseCase.state.place {
                Text(place.address)
                    .font(.Head.head2)
            }
            
        }
        .padding(.top, 10)
    }
}

// MARK: - MapButtonsView

private struct MapButtonsView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @Binding var isShowToastMessage: Bool
    @Binding var hasNotifications: Bool
    
    var trackList: [Track] {
        trackUseCase.mapTrackList
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                // TODO: notificationView로 이동
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        // TODO: 알림이 있을 경우 hasNotifications를 true로 변경
                        if hasNotifications {
                            HStack(alignment: .top, spacing: -5) {
                                Image(systemName: SystemImage.alert)
                                    .foregroundStyle(.platPurple)
                                Circle()
                                    .frame(width: 5, height: 5)
                                    .foregroundStyle(Color(.systemRed))
                            }
                        } else {
                            Image(systemName: SystemImage.alert)
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
            Spacer()
            
            Button {
                pathModel.presentSheet(.trackAppendSearch)
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        Image(systemName: SystemImage.letsPlat)
                            .foregroundStyle(.platPurple)
                    }
            }
            .padding(.bottom, 22)
            
            Button {
                if trackList.isEmpty {
                    isShowToastMessage = true
                } else {
                    pathModel.presentFullScreenCover(.platProcessing)
                }
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        Image(trackList.isEmpty ? .imgLetsplatDis : .imgLetsplat)
                            .frame(width: 22, height: 30)
                            .padding(.bottom, 4)
                            .overlay {
                                Text("\(trackList.count)")
                                    .foregroundStyle(trackList.isEmpty ? .gray7 : .platPurple)
                                    .font(.Body.body4)
                            }
                    }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrackMapView()
        .injectDIContainer()
}
