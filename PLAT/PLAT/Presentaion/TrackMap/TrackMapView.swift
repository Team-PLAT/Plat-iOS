//
//  TrackMapView.swift
//  PLAT
//
//  Created by 조우현 on 8/15/24.
//

import SwiftUI
import MapKit

struct TrackMapView: View {
    @Environment(TrackMapUseCase.self) private var trackMapUseCase: TrackMapUseCase
    
    var body: some View {
        Map()
    }
}

#Preview {
    TrackMapView()
        .environment(PreviewHelper.mockTrackMapUseCase)
}
