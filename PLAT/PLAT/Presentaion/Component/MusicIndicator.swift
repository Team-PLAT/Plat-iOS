//
//  MusicIndicator.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicIndicator

struct MusicIndicator: View {
    
    @Environment(TrackDetailUseCase.self) private var trackDetailUseCase
    
    private var isPaused: Bool {
        trackDetailUseCase.state.isPaused
    }
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                trackDetailUseCase.effect(.playPrevious)
            } label: {
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }
            
            Button {
                trackDetailUseCase.effect(.togglePlayback)
            } label: {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
            }
            
            Button {
                trackDetailUseCase.effect(.playNext)
            } label: {
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }
        }
        .foregroundStyle(.white)
    }
}

// MARK: - Preview

#Preview {
    MusicIndicator()
        .environment(PreviewHelper.mockTrackDetailUseCase)
}
