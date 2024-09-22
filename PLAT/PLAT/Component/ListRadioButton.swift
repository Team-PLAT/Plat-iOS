//
//  ListRadioButton.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import SwiftUI

struct ListRadioButton: View {
    
    enum State {
        case radio
        case none
    }
    
    let state: State
    let title: String
    let content: String
    let icon: ImageResource
    var isSelected: Bool = false
    var tapAction: () -> Void
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 10)
            ButtonTextView(title: title, content: content)
            Spacer()
            if state == .radio {
                RadioCircle(isSelected: isSelected)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .background(.platBackground)
        .onTapGesture {
            tapAction()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isSelected ? .platPurple : .platBackground, lineWidth: 2)
        }
        .disabled(isSelected)
    }
}

// MARK: - ButtonTextView

private struct ButtonTextView: View {
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.Body.body2)
                .foregroundStyle(.white)
            
            Text(content)
                .font(.Caption.caption1)
                .foregroundStyle(.gray7)
        }
    }
}

// MARK: - RadioCircle

private struct RadioCircle: View {
    
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.gray6)
            
            Circle()
                .frame(width: 16, height: 16)
                .foregroundStyle(.platBackground)
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(.platPurple)
                .opacity(isSelected ? 1 : 0)
        }
    }
}

#Preview {
    VStack {
        ListRadioButton(state: .radio, title: "Apple Music 연결됨", content: "Apple Music 스트리밍 계정과 연결되어 있어요", icon: .icnAppleMusic, isSelected: true) {}
        ListRadioButton(state: .radio, title: "Apple Music 연결됨", content: "Apple Music 스트리밍 계정과 연결되어 있어요", icon: .icnAppleMusic) {}
        ListRadioButton(state: .none, title: "Apple Music 연결됨", content: "Apple Music 스트리밍 계정과 연결되어 있어요", icon: .icnAppleMusic) {}
    }
}
