//
//  AccountSettingsView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @Environment(UserUseCase.self) private var userUseCase
    
    @State private var isStreamAccountSettingsViewPresented = false
    
    var connectedStreamAccountInfo: ListSection.Info {
        return ListSection.Info(title: "연동된 스트리밍 계정", streamAccount: userUseCase.state.user.streamAccount) {
            isStreamAccountSettingsViewPresented.toggle()
        }
    }
    
    var logoutInfo: ListSection.Info {
        return ListSection.Info(title: "로그아웃", isDestructive: true) {
            // TODO: 로그아웃 alert
        }
    }
    
    var accountDeletion: ListSection.Info {
        return ListSection.Info(title: "계정 탈퇴") {
            // TODO: 계정탈퇴 alert
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
        .navigationDestination(isPresented: $isStreamAccountSettingsViewPresented) {
            StreamAccountSettingsView()
                .toolbarRole(.editor)
        }
    }
}

#Preview {
    AccountSettingsView()
        .environment(PreviewHelper.mockUserUseCase)
}
