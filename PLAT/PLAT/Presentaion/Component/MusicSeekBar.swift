//
//  MusicSeekBar.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - MusicSeekBar

struct MusicSeekBar: View {
    
    @State private var isMoving = false
    
    @Binding private(set) var currentDuration: Double
    
    let totalDuration: Double
    
    private var progress: Double {
        currentDuration / totalDuration
    }
    
    private var leftDuration: Double {
        totalDuration - currentDuration
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Slider(
                value: $currentDuration,
                in: 0...totalDuration,
                onEditingChanged: {
                    isMoving = $0
                }
            )
            .controlSize(.mini)
            .tint(.platPurple)
            
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
        currentDuration: .constant(300),
        totalDuration: 365
    )
}
