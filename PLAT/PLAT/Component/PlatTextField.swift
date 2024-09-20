//
//  PlatTextField.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import SwiftUI

struct PlatTextField: View {
    
    @Binding private(set) var text: String
    
    let placeholder: String
    let state: State
    
    enum State {
        case normal
        case warning
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.Body.body5)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(state == .normal ? .gray9 : .red, lineWidth: 1)
            }
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
    }
}

#Preview {
    PlatTextField(
        text: .constant("안녕하세요"),
        placeholder: "텍스트를 입력해주세요",
        state: .warning
    )
}
