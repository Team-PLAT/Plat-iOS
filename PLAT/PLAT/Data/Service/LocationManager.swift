//
//  LocationManager.swift
//  PLAT
//
//  Created by 조우현 on 8/18/24.
//

import SwiftUI
import Combine
import MapKit

@Observable
final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private static let refreshTime: Double = 10
    private static let coordinateSpan: Double = 0.015
    
    private(set) var locationPublisher: CurrentValueSubject<CLLocation, Never>
    private var timerCancellable: AnyCancellable?
    
    var location: CLLocation?
    var position: MapCameraPosition
    
    /// Initializer
    override init() {
        
        // Publisher 초기화
        self.locationPublisher = CurrentValueSubject(CLLocation(latitude: 0, longitude: 0))
        
        // Position 초기화
        self.position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(
                    latitudeDelta: LocationManager.coordinateSpan,
                    longitudeDelta: LocationManager.coordinateSpan
                )
            )
        )
        super.init()
        
        // LocationManager 설정
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 10초마다 CLLocation 값 방출
        timerCancellable = Timer.publish(
            every: LocationManager.refreshTime,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            if let location = self?.location {
                self?.locationPublisher.send(location)
            }
        }
    }
    
    /// 위치 정보를 받아오기 위해 권한을 요청합니다.
    func requestLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    /// Location 정보가 업데이트 될 때 호출되는 Delegate 메서드입니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 만약 Location이 한번도 전달되지 않았다면
        // 타이머 주기와 상관없이 첫번째 값 방출
        if self.location == nil {
            self.locationPublisher.send(location)
        }
        
        // 위치 정보 업데이트
        self.location = location
        self.position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: LocationManager.coordinateSpan,
                    longitudeDelta: LocationManager.coordinateSpan
                )
            )
        )
    }
    
    /// Location을 받아오지 못해 Error 발생시 호출되는 Delegate 메서드입니다.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
