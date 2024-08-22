//
//  AccountSettingsView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(AuthUseCase.self) private var authUseCase
    
    @State private var isLogoutAlertPresented = false
    @State private var isAccountDeletionAlertPresented = false
    
    var connectedStreamAccountInfo: ListSection.Info {
        return ListSection.Info(title: "연동된 스트리밍 계정", streamAccount: userUseCase.state.user.streamAccount) {
            pathModel.paths.append(.streamAccountSettingsView)
        }
    }
    
    var logoutInfo: ListSection.Info {
        return ListSection.Info(title: "로그아웃", isDestructive: true) {
            isLogoutAlertPresented.toggle()
        }
    }
    
    var accountDeletion: ListSection.Info {
        return ListSection.Info(title: "계정 탈퇴") {
            isAccountDeletionAlertPresented.toggle()
        }
    }
    
    var body: some View {
        VStack(spacing: 42) {
            ListSection(infoList: [connectedStreamAccountInfo])
            ListSection(infoList: [logoutInfo, accountDeletion])
            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("계정 설정")
        .navigationBarTitleDisplayMode(.inline)
        .background(.platBackground)
        .alert("계정을 삭제하시겠어요?", isPresented: $isAccountDeletionAlertPresented) {
            Button("돌아가기", role: .cancel) { }
            Button("삭제하기", role: .destructive) {
                authUseCase.deleteAccount()
            }
        } message: {
            Text("계정을 삭제하면, 그종안 올린 트랙과 프로필,\n플레이리스트 등의 정보가 모두 삭제됩니다.")
        }
        .alert("로그아웃 하시겠어요?", isPresented: $isLogoutAlertPresented) {
            Button("돌아가기", role: .cancel) { }
            Button("로그아웃", role: .destructive) {
                authUseCase.logout()
            }
        }
    }
}

#Preview {
    AccountSettingsView()
        .environment(PreviewHelper.mockUserUseCase)
        .environment(PathModel())
        .environment(PreviewHelper.mockAuthUseCase)
}
