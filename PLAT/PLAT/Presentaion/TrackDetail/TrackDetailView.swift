//
//  TrackDetailView.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - TrackDetailView

struct TrackDetailView: View {
    
    // TODO: 이후 상위에서 주입 받기
    // TODO: Stub 객체 교체하기
    @State private var trackDetailUseCase: TrackDetailUseCase = .init(
        track: MockDataBuilder.track,
        trackService: StubTrackService(),
        musicController: StubMusicController()
    )
    
    var body: some View {
        VStack {
            HeaderView()
        }
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    var body: some View {
        HStack {
            
        }
    }
}

// MARK: - Preview

#Preview {
    TrackDetailView()
}
