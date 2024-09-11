//
//  MusicIndicator.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicIndicator

struct MusicIndicator: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlerUseCase
    
    private var isPaused: Bool {
        musicControlerUseCase.state.isPaused
    }
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                // TODO: 이전 음악 재생
            } label: {
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
            }
            
            Button {
                Task {
                    musicControlerUseCase.effect(.togglePlayback)
                }
            } label: {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
            
            Button {
                // TODO: 다음 음악 재생
            } label: {
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
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
