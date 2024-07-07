//
//  NicknameSettingsView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct NicknameSettingsView: View {
    
    @Environment(UserUseCase.self) private var userUseCase
    @State private(set) var nicknameText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("새로운 닉네임을 입력해주세요")
                .font(.Head.head4)
                .padding(.horizontal, 25)
                .padding(.bottom, 12)
            
            PlatTextField(
                text: $nicknameText,
                placeholder: "닉네임을 입력해주세요.",
                state: .normal
            )
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
            
            NicknameGuide()
                .padding(.horizontal, 24)
        }
        .navigationTitle("닉네임 변경")
        .navigationBarTitleDisplayMode(.inline)
        .background(.platBackground)
    }
}

// MARK: - NicknameGuide

private struct NicknameGuide: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("닉네임은 최대 20자까지 작성 가능해요.")
            Text("닉네임으로 영어와 한글, 숫자, 특수문자(-)를 사용할 수 있으며,")
            Text("공백이나 욕설, 비속어는 사용할 수 없어요.")
        }
        .font(.Caption.caption1)
        .foregroundStyle(.gray7)
    }
}

#Preview {
    NicknameSettingsView(nicknameText: "IPSUM_LOREM")
        .environment(PreviewHelper.mockUserUseCase)
}
