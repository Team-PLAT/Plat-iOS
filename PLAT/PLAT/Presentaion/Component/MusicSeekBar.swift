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
    
    let totalDuration: Double
    
    private var leftDuration: Double {
        totalDuration - musicControlUseCase.state.currentDuration
    }
    
    var body: some View {
        
        @Bindable var musicControlUseCase = musicControlUseCase
        
        VStack(spacing: 12) {
            Slider(
                value: $sliderValue,
                in: 0...totalDuration,
                onEditingChanged: { editing in
                    if editing {
                        Task {
                            await musicControlUseCase.effect(.updatePlayer(duration: sliderValue))
                        }
                        
                        musicControlUseCase.state.currentDuration = sliderValue
                        print("수정 끝남")
                        print(sliderValue)
                    } else {
                        Task {
                            await musicControlUseCase.effect(.updatePlayer(duration: musicControlUseCase.state.currentDuration))
                        }
                    }
                }
            )
            .onAppear {
                let thumbImage = UIImage(systemName: "circle.fill")
                UISlider.appearance().setThumbImage(thumbImage, for: .normal)
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
