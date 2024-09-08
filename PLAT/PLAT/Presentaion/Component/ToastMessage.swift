//
//  ToastMessage.swift
//  PLAT
//
//  Created by 김민준 on 9/8/24.
//

import SwiftUI

struct ToastMessage: View {
    
    let message: String
    
    @State private var opacity: CGFloat = 0
    @Binding private(set) var isToastPresented: Bool
    
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
        .opacity(opacity)
        .onChange(of: isToastPresented) { _, flag in
            if flag { toggleToast() }
        }
    }
    
    /// 토스트 메시지를 출력 후 사라지게 합니다.
    private func toggleToast() {
        withAnimation(.easeInOut) {
            opacity = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    opacity = 0
                    isToastPresented = false
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ToastMessage(
        message: "트랙을 추가할 플레이리스트가 없어요.",
        isToastPresented: .constant(false)
    )
}
