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
    @Environment(TrackMapUseCase.self) private var trackMapUseCase: TrackMapUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var locationManager = LocationManager()
    @State private var selectedTrackId: Track.ID?
    @State private var showTrackDetail = false
    @State private var hasNotifications = false
    @State private var playlist: Playlist?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
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
                                selectedTrackId = track.id
                                showTrackDetail.toggle()
                            }
                    }
                }
                
                if let location = locationManager.location {
                    MapCircle(center: location.coordinate, radius: CLLocationDistance(500))
                        .foregroundStyle(.platDarkpurple.opacity(0.5))
                }
            }
            
            if showTrackDetail == false {
                MapComponentsView(hasNotifications: $hasNotifications, playlist: $playlist, selectedTrackId: $selectedTrackId, showTrackDetail: $showTrackDetail)
            }
        }
        .fullScreenCover(isPresented: $showTrackDetail) {
            if let _ = selectedTrackId {
                TrackDetailView()
                    .presentationBackground(.thinMaterial.opacity(0.5))
            }
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
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding var hasNotifications: Bool
    @Binding var playlist: Playlist?
    @Binding var selectedTrackId: Track.ID?
    @Binding var showTrackDetail: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                MapAddressView()
                Spacer()
                MapButtonsView(
                    hasNotifications: $hasNotifications,
                    playlist: $playlist
                )
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 18)
            
            if musicControlUseCase.state.isStreaming {
                // TODO: 더미데이터 변경
                @Bindable var musicControlUseCase = musicControlUseCase
                MiniMusicPlayer(
                    isPaused: $musicControlUseCase.state.isPaused,
                    track: $musicControlUseCase.state.isPlayingTrack,
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: musicControlUseCase.state.music?.duration ?? 0
                )
                .padding(.bottom, 16)
                .onTapGesture {
                    selectedTrackId = musicControlUseCase.state.isPlayingTrack?.id
                    showTrackDetail.toggle()
                }
            }
        }
        .padding(.horizontal, 18)
        
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
    @State private var isTrackAppendViewSheet = false
    @State private var detent: PresentationDetent = .large
    @Binding var hasNotifications: Bool
    @State private var isPlattingSheet = false
    @Binding var playlist: Playlist?
    
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
                isTrackAppendViewSheet = true
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
            .sheet(isPresented: $isTrackAppendViewSheet, onDismiss: {
                detent = .large
            }) {
                TrackAppendSearchView(isTrackAppendViewSheet: $isTrackAppendViewSheet, detent: $detent)
                    .presentationDragIndicator(.visible)
                    .tint(.white)
                    .presentationDetents([detent])
            }
            
            Button {
                isPlattingSheet.toggle()
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        Image(.imgLetsplat)
                            .frame(width: 22, height: 30)
                            .foregroundStyle(.platPurple)
                            .padding(.bottom, 4)
                            .overlay {
                                Text("\(playlist?.trackList.count ?? 0)")
                                    .foregroundStyle(.platPurple)
                                    .font(.Body.body4)
                            }
                    }
            }
            .fullScreenCover(isPresented: $isPlattingSheet) {
                PlattingView(playList: $playlist)
                    .presentationBackground(.black.opacity(0.8))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrackMapView()
        .environment(PreviewHelper.mockMusicControlUseCase)
}
