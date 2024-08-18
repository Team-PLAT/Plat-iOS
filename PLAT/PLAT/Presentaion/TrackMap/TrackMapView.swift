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
    
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: MockDataBuilder.currentLocation.latitude, longitude: MockDataBuilder.currentLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
    @State private var currentCoordinate = CLLocationCoordinate2D(latitude: MockDataBuilder.currentLocation.latitude, longitude: MockDataBuilder.currentLocation.longitude)
    @State private var selectedTrack: Track?
    @State private var showTrackDetail = false
    @State private var hasNotifications = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $position, interactionModes: []) {
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)) {
                    CurrentLocationDotView()
                }
                
                ForEach(MockDataBuilder.trackList) { track in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: track.location.latitude, longitude: track.location.longitude)) {
                        CustomMarkerView(track: track)
                            .onTapGesture {
                                selectedTrack = track
                                showTrackDetail.toggle()
                            }
                    }
                }
                
                MapCircle(center: currentCoordinate, radius: CLLocationDistance(500))
                    .foregroundStyle(.platDarkpurple.opacity(0.5))
            }
            
            if showTrackDetail == false {
                MapComponentsView(hasNotifications: $hasNotifications)
            }
        }
        .fullScreenCover(isPresented: $showTrackDetail) {
            if let track = selectedTrack {
                TrackDetailView(track: track)
                    .presentationBackground(.thinMaterial.opacity(0.5))
            } else {
                Text("No Track Selected")
            }
        }
        .onChange(of: showTrackDetail) { newValue, _ in
            print("showTrackDetail changed: \(newValue)")
        }
    }
}

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
    @Binding var hasNotifications: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 100) {
            MapAddressView()
            MapButtonsView(hasNotifications: $hasNotifications)
                .padding(.bottom, 22)
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
        .padding(.leading, 18)
        .padding(.top, 10)
    }
}

// MARK: - MapButtonsView

private struct MapButtonsView: View {
    @Environment(TrackMapUseCase.self) private var trackMapUseCase: TrackMapUseCase
    @Binding var hasNotifications: Bool
    
    var body: some View {
        VStack {
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
                                Image(systemName: "bell")
                                    .foregroundStyle(.platPurple)
                                Circle()
                                    .frame(width: 5, height: 5)
                                    .foregroundStyle(Color(.systemRed))
                            }
                        } else {
                            Image(systemName: "bell")
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
            Spacer()
            
            Button {
                // TODO: TrackAppendView로 이동(sheet)
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.platBackground)
                    .overlay {
                        Image(systemName: "plus.square.on.square")
                            .foregroundStyle(.platPurple)
                    }
            }
            .padding(.bottom, 22)
            
            Button {
                Task {
                    let playlist = await trackMapUseCase.creatPlatPlaylist(currentLocation: MockDataBuilder.currentLocation)
                    // TODO: PlatProcessingView로 이동
                }
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
                                Text("\(MockDataBuilder.trackList.count)")
                                    .foregroundStyle(.platPurple)
                                    .font(.Body.body4)
                            }
                    }
            }
        }
    }
}

// MARK: - CurrentLocationDotView

struct CurrentLocationDotView: View {
    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.platPurple)
            
            Circle()
                .frame(width: 16, height: 16)
                .foregroundStyle(.gray3)
                .overlay {
                    Circle()
                        .frame(width: 11, height: 11)
                        .foregroundStyle(.platPurple)
                }
        }
    }
}

// MARK: - Preview
#Preview {
    TrackMapView()
        .environment(PreviewHelper.mockTrackMapUseCase)
}
