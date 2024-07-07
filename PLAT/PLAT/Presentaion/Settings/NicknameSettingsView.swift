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
            
            Spacer()
                .frame(height: 12)
            
            PlatTextField(
                text: $nicknameText,
                placeholder: "닉네임을 입력해주세요.",
                state: .normal
            )
            .padding(.horizontal, 18)
        }
        .navigationTitle("닉네임 변경")
        .navigationBarTitleDisplayMode(.inline)
        .background(.platBackground)
    }
}

#Preview {
    NicknameSettingsView(nicknameText: "IPSUM_LOREM")
        .environment(PreviewHelper.mockUserUseCase)
}
