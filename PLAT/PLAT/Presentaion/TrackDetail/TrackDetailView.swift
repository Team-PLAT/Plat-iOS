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
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .environment(trackDetailUseCase)
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(.imgMarker)
                
                Group {
                    if let placeName = trackDetailUseCase.state.place.name {
                        Text(placeName)
                        
                    } else {
                        Text(trackDetailUseCase.state.place.address)
                    }
                }
                .font(.Head.head2)
                .foregroundStyle(.white)
                
                Spacer()
                
                DismissButton {
                    //
                }
            }
            
            Text(trackDetailUseCase.state.place.address)
                .font(.Body.body3)
                .foregroundStyle(.white)
                .padding(.leading, 24)
        }
    }
}

// MARK: - Preview

#Preview {
    TrackDetailView()
}
