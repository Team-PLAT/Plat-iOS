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
    
    @State private var locationManager = MapKitLocationServiceImpl()
    @State private var hasNotifications = false
    @State private var playlist: Playlist?
    @State private var isShowToastMessage: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topLeading) {
                if #available(iOS 18.0, *) {
                    MapView(
                        locationManager: $locationManager
                    )
                    .toolbarVisibility(.hidden, for: .navigationBar)
                } else {
                    MapView(
                        locationManager: $locationManager
                    )
                }
                
                MapComponentsView(
                    hasNotifications: $hasNotifications,
                    playlist: $playlist,
                    isShowToastMessage: $isShowToastMessage
                )
            }
            .onReceive(locationManager.locationPublisher) { location in
                print("""
            [위치 업데이트]
            - 위도: \(Double(location.coordinate.latitude).rounded())
            - 경도: \(Double(location.coordinate.longitude).rounded())
            """)
                
                // TODO: 트랙 리스트 업데이트
                // TODO: 플레이리스트 생성
            }
            
            ToastMessage(message: "플레이리스트를 생성할 트랙이 없어요", isToastPresented: $isShowToastMessage)
        }
        //        .onAppear {
        //            Task {
        //                playlist = await musicControlUseCase.fetchMusicInfoApi(music: track.music)
        //            }
        //        }
    }
}

// MARK: - MapView

private struct MapView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding private(set) var locationManager: MapKitLocationServiceImpl
    
    var body: some View {
        Map(
            position: $locationManager.position,
            interactionModes: []
        ) {
            UserAnnotation()
            
            // TODO: 실제 데이터로 변경
            ForEach(MockDataBuilder.trackList) { track in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: track.location.latitude, longitude: track.location.longitude)) {
                    CustomMarkerView(track: track)
                        .onTapGesture {
                            musicControlUseCase.state.isPlayingTrack = track
                            musicControlUseCase.effect(.setup(music: track.music))
                            pathModel.presentFullScreenCover(.trackDetail)
                        }
                }
            }
            
            if let location = locationManager.location {
                MapCircle(center: location.coordinate, radius: CLLocationDistance(500))
                    .foregroundStyle(.platDarkpurple.opacity(0.5))
            }
        }
    }
}

// MARK: - CustomMarkerView

private struct CustomMarkerView: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var playlistMusic: Music?
    
    let track: Track
    
    var body: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.gray3)
            .overlay {
                if let albumImageUrl = playlistMusic?.albumImageUrl {
                    AsyncImage(url: URL(string: albumImageUrl)) { phase in
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
                } else {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.gray3)
                }
            }
            .onAppear {
                Task {
                    playlistMusic = await musicControlUseCase.fetchMusicInfoApi(music: track.music)
                }
            }
    }
}


// MARK: - MapComponentsView

private struct MapComponentsView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding var hasNotifications: Bool
    @Binding var playlist: Playlist?
    @Binding var isShowToastMessage: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                MapAddressView()
                Spacer()
                MapButtonsView(
                    isShowToastMessage: $isShowToastMessage, hasNotifications: $hasNotifications,
                    playlist: $playlist
                )
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 18)
            
            if musicControlUseCase.state.isStreaming {
                @Bindable var musicControlUseCase = musicControlUseCase
                MiniMusicPlayer(
                    isPaused: $musicControlUseCase.state.isPaused,
                    track: $musicControlUseCase.state.isPlayingTrack,
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: musicControlUseCase.state.music?.duration ?? 0
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
    var body: some View {
        HStack {
            Image(.imgMarker)
            // 위치에 따라 자동으로 변경
            Text("포항시 남구 지곡동")
                .font(.Head.head2)
        }
        .padding(.top, 10)
    }
}

// MARK: - MapButtonsView

private struct MapButtonsView: View {
    
    @Environment(PathModel.self) private var pathModel
    
    @Binding var isShowToastMessage: Bool
    @Binding var hasNotifications: Bool
    @Binding var playlist: Playlist?
    
    var isTrackListEmpty: Bool {
        playlist?.trackList.isEmpty ?? true
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
                if isTrackListEmpty {
                    isShowToastMessage = true
                } else {
                    pathModel.presentFullScreenCover(.platProcessing)
                }
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        Image(isTrackListEmpty ? .imgLetsplatDis : .imgLetsplat)
                            .frame(width: 22, height: 30)
                            .padding(.bottom, 4)
                            .overlay {
                                Text("\(playlist?.trackList.count ?? 0)")
                                    .foregroundStyle(isTrackListEmpty ? .gray7 : .platPurple)
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
        .environment(PreviewHelper.mockMusicControlUseCase)
        .injectDIContainer()
}
