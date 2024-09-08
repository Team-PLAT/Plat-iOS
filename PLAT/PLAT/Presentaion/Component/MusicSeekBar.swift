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
    @State private var currentDuration: Double = 0.0

    let totalDuration: Double
    
    private var progress: Double {
        currentDuration / totalDuration
    }
    
    private var leftDuration: Double {
        totalDuration - currentDuration
    }
    
    var body: some View {

        @Bindable var musicControlUseCase = musicControlUseCase
        
        VStack(spacing: 12) {
            Slider(
                value: $musicControlUseCase.state.currentDuration,
                in: 0...totalDuration,
                onEditingChanged: { editing in
                    isEditing = editing
                    if !editing {
                        Task {
                            await musicControlUseCase.effect(.updatePlayer(duration: currentDuration))
                        }
                    }
                }
            )
            .onAppear {
                let thumbImage = UIImage(systemName: "circle.fill")
                UISlider.appearance().setThumbImage(thumbImage, for: .disabled)
            }
            .accentColor(.platPurple)
            
            HStack {
                Text(musicControlUseCase.state.currentDuration.musicTimeFormat)
                Spacer()
                Text("-\(leftDuration.musicTimeFormat)")
            }
            .font(.Body.body5)
            .foregroundStyle(.gray7)
        }
        .padding()
        .onAppear {
           
            isEditing = false
        }
    }
}

// MARK: - Preview

//#Preview {
//    MusicSeekBar(
//        currentDuration: 300,
//        totalDuration: 365
//    )
//}
