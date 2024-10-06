//
//  MusicSeekBar.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicSeekBar

struct MusicSeekBar: View {
    
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var isEditing = false
    @State private var sliderValue: Double = 0.0
    
    private let millisecondsUnit: Double = 1000
    
    let totalDuration: Double
    
    private var leftDuration: Double {
        (totalDuration / millisecondsUnit) - musicControlUseCase.state.currentDuration
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Slider(
                value: $sliderValue,
                in: 0...totalDuration,
                onEditingChanged: { editing in
                    if !editing {
                        musicControlUseCase.effect(.updatePlayer(duration: sliderValue / millisecondsUnit))
                    }
                }
            )
            HStack {
                Text(musicControlUseCase.state.currentDuration.musicTimeFormat)
                Spacer()
                Text("-\(leftDuration.musicTimeFormat)")
            }
            .font(.Body.body5)
            .foregroundStyle(.gray7)
        }
        .onChange(of: musicControlUseCase.state.currentDuration) {
            if !isEditing {
                sliderValue = musicControlUseCase.state.currentDuration * millisecondsUnit
            }
        }
        .onAppear {
            let thumbImage = UIImage(systemName: "circle.fill")
            UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        }
        .accentColor(.platPurple)
    }
}

// MARK: - Preview

#Preview {
    MusicSeekBar(totalDuration: 378.0)
}
