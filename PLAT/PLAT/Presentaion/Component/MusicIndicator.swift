//
//  MusicIndicator.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicIndicator

struct MusicIndicator: View {
    
    let isPaused: Bool
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                // TODO: 이전 음악 재생
            } label: {
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }
            
            Button {
                // TODO: 일시정지 / 재생 토글
            } label: {
                Image(systemName: isPaused 
                      ? "play.fill" :  "pause.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
            }
            
            Button {
                // TODO: 다음 음악 재생
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
    MusicIndicator(isPaused: false)
}
