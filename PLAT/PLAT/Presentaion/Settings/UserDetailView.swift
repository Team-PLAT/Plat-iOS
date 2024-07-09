//
//  UserDetailView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct UserDetailView: View {
    
    @Environment(UserUseCase.self) private var userUseCase: UserUseCase
    @Environment(InfoUseCase.self) private var infoUseCase: InfoUseCase
    @Environment(StreamAccountUseCase.self) private var streamAccountUseCase: StreamAccountUseCase
    
    var body: some View {
        VStack {
            Text("내 계정")
                .font(.Head.head5)
                .foregroundStyle(.white)
                .padding(.top, 8)
                .padding(.bottom, 24)
            
            ProfileImageView()
                .padding(.bottom, 56)
            SettingListView()
            Spacer()
        }
        .background(.platBackground)
        .tint(.white)
    }
}

// MARK: - ProfileImageView

private struct ProfileImageView: View {
    
    @Environment(UserUseCase.self) private var userUseCase
    
    var body: some View {
        Button {
            userUseCase.updateProfileImage()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "")
                    .resizable()
                    .frame(width: 160, height: 160)
                    .background(.gray4)
                    .clipShape(Circle())
                
                CameraButton()
                    .padding(.trailing, -10)
                    .padding(.bottom)
            }
        }
    }
    
    private struct CameraButton: View {
        var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(.platBlack)
                    .frame(width: 58, height: 58)
                
                Circle()
                    .foregroundStyle(.gray7)
                    .background(.gray7)
                    .frame(width: 46, height: 46)
                    .clipShape(.circle)
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

// MARK: - SettingListView

private struct SettingListView: View {
    
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(InfoUseCase.self) private var infoUseCase
    
    @State private var isNicknameSettingsViewPresented = false
    @State private var isAccountSettingsViewPresented = false
    @State private var isAboutPlatSettingsViewPresented = false
    
    var nicknameInfo: ListSection.Info {
        return ListSection.Info(title: "닉네임") {
            isNicknameSettingsViewPresented.toggle()
        }
    }
    
    var accountSettingsInfo: ListSection.Info {
        return ListSection.Info(title: "계정설정") {
            isAccountSettingsViewPresented.toggle()
        }
    }
    
    var aboutPlatInfo: ListSection.Info {
        return ListSection.Info(title: "About PLAT") {
            isAboutPlatSettingsViewPresented.toggle()
        }
    }
    
    var supportInfo: ListSection.Info {
        .init(title: "지원", icon: "rectangle.portrait.and.arrow.right") {
            infoUseCase.checkSupport()
        }
    }

    var body: some View {
        Group {
            VStack(spacing: 42) {
                ListSection(infoList: [nicknameInfo, accountSettingsInfo])
                ListSection(infoList: [aboutPlatInfo, supportInfo])
            }
        }
        .navigationDestination(isPresented: $isNicknameSettingsViewPresented) { NicknameSettingsView(nicknameText: "")
                .toolbarRole(.editor)
        }
        .navigationDestination(isPresented: $isAccountSettingsViewPresented) {
            AccountSettingsView()
                .toolbarRole(.editor)
        }
        .navigationDestination(isPresented: $isAboutPlatSettingsViewPresented) {
            AboutPlatSettingsView()
                .toolbarRole(.editor)
        }
    }
}

#Preview {
    UserDetailView()
        .environment(PreviewHelper.mockUserUseCase)
        .environment(PreviewHelper.mockInfoUseCase)
        .environment(PreviewHelper.mockStreamAccountUseCase)
}
