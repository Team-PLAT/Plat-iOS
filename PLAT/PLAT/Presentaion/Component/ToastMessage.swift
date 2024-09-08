//
//  ToastMessage.swift
//  PLAT
//
//  Created by 김민준 on 9/8/24.
//

import SwiftUI

struct ToastMessage: View {
    
    let message: String
    
    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: SystemImage.exclamationmark)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.platPurple)
            
            Text(message)
                .foregroundStyle(.white)
                .font(.Body.body1)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .background(.platBlack)
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}

// MARK: - Preview

#Preview {
    ToastMessage(message: "트랙을 추가할 플레이리스트가 없어요.")
}
