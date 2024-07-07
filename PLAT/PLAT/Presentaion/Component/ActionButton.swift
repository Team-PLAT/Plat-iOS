//
//  ActionButton.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import SwiftUI

struct ActionButton: View {
    
    enum State {
        case enabled
        case disabled
        
        var foreground: Color {
            switch self {
            case .enabled: return .white
            case .disabled: return .gray7
            }
        }
        
        var background: Color {
            switch self {
            case .enabled: return .platPurple
            case .disabled: return .gray9
            }
        }
    }
    
    let state: State
    let title: String
    var tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Text(title)
                .font(.Head.head4)
                .foregroundStyle(state.foreground)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(state.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(state == .disabled)
    }
}

#Preview {
    VStack {
        ActionButton(state: .enabled, title: "변경 완료", tapAction: {})
        ActionButton(state: .disabled, title: "변경 완료", tapAction: {})
    }
}
