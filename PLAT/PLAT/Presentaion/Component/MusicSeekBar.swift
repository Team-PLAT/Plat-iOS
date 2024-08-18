//
//  MusicSeekBar.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicSeekBar

struct MusicSeekBar: View {
    
    let currentDuration: Double
    let totalDuration: Double
    
    private var progress: Double {
        currentDuration / totalDuration
    }
    
    private var leftDuration: Double {
        totalDuration - currentDuration
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ProgressView(value: progress)
                .tint(.platPurple)
                .background(.secondary.opacity(0.32))
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
            
            HStack {
                Text(currentDuration.musicTimeFormat)
                Spacer()
                Text("-\(leftDuration.musicTimeFormat)")
            }
            .font(.Body.body5)
            .foregroundStyle(.gray7)
        }
    }
}

// MARK: - Preview

#Preview {
    MusicSeekBar(
        currentDuration: 300,
        totalDuration: 365
    )
}
