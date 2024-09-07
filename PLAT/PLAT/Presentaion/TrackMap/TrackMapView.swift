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
    
    @State private var selectedTrackId: Track.ID?
    @State private var showTrackDetail = false
    @State private var hasNotifications = false
    @State private var playlist: Playlist?
    
    var body: some View {
        @Bindable var trackMapUseCase = trackMapUseCase
        ZStack(alignment: .topLeading) {
            Map(
                position: $trackMapUseCase.locationManager.position,
                interactionModes: []
            ) {
                UserAnnotation()
                
                ForEach(trackMapUseCase.state.trackList) { track in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: track.location.latitude, longitude: track.location.longitude)) {
                        CustomMarkerView(track: track)
                            .onTapGesture {
                                selectedTrackId = track.id
                                musicControlUseCase.state.isPlayingId = selectedTrackId ?? 0
                                showTrackDetail.toggle()
                            }
                    }
                }
                
                if let location = trackMapUseCase.locationManager.location {
                    MapCircle(center: location.coordinate, radius: CLLocationDistance(500))
                        .foregroundStyle(.platDarkpurple.opacity(0.5))
                }
            }
            
            if showTrackDetail == false {
                MapComponentsView(hasNotifications: $hasNotifications, playlist: $playlist, selectedTrackId: $selectedTrackId)
            }
        }
        .fullScreenCover(isPresented: $showTrackDetail) {
            if let trackId = selectedTrackId {
                TrackDetailView(trackId: trackId)
                    .presentationBackground(.thinMaterial.opacity(0.5))
            }
        }
        .onAppear {
            if let location = trackMapUseCase.locationManager.location {
                print("Current Location: \(location)")
                trackMapUseCase.fetchTrackList(currentLocation: Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                Task {
                    playlist = await trackMapUseCase.createPlatPlaylist(currentLocation: Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                    print("Playlist created with \(playlist?.trackList.count ?? 0) tracks")
                }
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
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @Binding var hasNotifications: Bool
    @Binding var playlist: Playlist?
    @Binding var selectedTrackId: Track.ID?
    
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
            
            if musicControlUseCase.state.isStreaming {
                // TODO: 더미데이터 변경
                @Bindable var musicControlUseCase = musicControlUseCase
                MiniMusicPlayer(
                    isPaused: $musicControlUseCase.state.isPaused,
                    track: MockDataBuilder.trackList.first { $0.id == musicControlUseCase.state.isPlayingId } ?? MockDataBuilder.track,
                    currentDuration: musicControlUseCase.state.currentDuration,
                    totalDuration: musicControlUseCase.state.music?.duration ?? 0
                )
                .padding(.bottom, 16)
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
    @Environment(TrackMapUseCase.self) private var trackMapUseCase: TrackMapUseCase
    @State private var isTrackAppendViewSheet = false
    @State private var detent: PresentationDetent = .fraction(0.25)
    @Binding var hasNotifications: Bool
    @State private var isPlattingSheet = false
    // TODO: 목 데이터 제거하고 실제 데이터 연결
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
                // TODO: TrackAppendView로 이동(sheet)
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
                detent = .fraction(0.25)
            }) {
                TrackAppendSearchView(isTrackAppendViewSheet: $isTrackAppendViewSheet, detent: $detent)
                    .presentationDragIndicator(.visible)
                    .tint(.platPurple)
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

// MARK: - Functions

func getMapVisibleCoordinates(mapView: MKMapView) {
    // 현재 보이는 맵의 Rect를 가져옴
    let visibleMapRect = mapView.visibleMapRect
    
    // 최상단 왼쪽 좌표 (북서쪽)
    let topLeftPoint = MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY)
    let topLeftCoordinate = topLeftPoint.coordinate
    
    // 최하단 오른쪽 좌표 (남동쪽)
    let bottomRightPoint = MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.maxY)
    let bottomRightCoordinate = bottomRightPoint.coordinate
    
    print("Top Left Coordinate: \(topLeftCoordinate.latitude), \(topLeftCoordinate.longitude)")
    print("Bottom Right Coordinate: \(bottomRightCoordinate.latitude), \(bottomRightCoordinate.longitude)")
}

// MARK: - Preview
#Preview {
    TrackMapView()
        .environment(PreviewHelper.mockTrackMapUseCase)
        .environment(PreviewHelper.mockMusicControlUseCase)
}
