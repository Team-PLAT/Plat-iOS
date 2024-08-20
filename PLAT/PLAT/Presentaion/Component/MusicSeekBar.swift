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
    
    @State private var isMoving = false
    
    let totalDuration: Double
    
    private var progress: Double {
        musicControlUseCase.currentDuration / totalDuration
    }
    
    private var leftDuration: Double {
        totalDuration - musicControlUseCase.currentDuration
    }
    
    var body: some View {
        @Bindable var musicControlerUseCase = musicControlUseCase
        VStack(spacing: 12) {
            Slider(
                value: $musicControlerUseCase.currentDuration,
                in: 0...totalDuration,
                onEditingChanged: {
                    isMoving = $0
                }
            )
            .controlSize(.mini)
            .tint(.platPurple)
            
            HStack {
                Text(musicControlUseCase.currentDuration.musicTimeFormat)
                Spacer()
                Text("-\(leftDuration.musicTimeFormat)")
            }
            .font(.Body.body5)
            .foregroundStyle(.gray7)
        }
        .onChange(of: isMoving) { _, bool in
            if bool {
                print("움직이고 있음")
                musicControlerUseCase.effect(.startMovePosition)
            } else {
                print("움직임 끝남")
                musicControlerUseCase.effect(.endMovePosition)
            }
        }
    }
}

// MARK: - CustomSlider

struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let thumbSize: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let thumbPosition = (value - range.lowerBound) / (range.upperBound - range.lowerBound) * sliderWidth

            ZStack(alignment: .leading) {
                // 슬라이더의 트랙
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 4)
                
                // 핸들 (Thumb)
                Circle()
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.blue)
                    .offset(x: thumbPosition - thumbSize / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                let newValue = min(max(0, drag.location.x / sliderWidth), 1) * (range.upperBound - range.lowerBound) + range.lowerBound
                                value = newValue
                            }
                    )
            }
            .padding(.horizontal, thumbSize / 2)
        }
        .frame(height: thumbSize)
    }
}

// MARK: - Preview

#Preview {
    MusicSeekBar(
        totalDuration: 365
    )
}
