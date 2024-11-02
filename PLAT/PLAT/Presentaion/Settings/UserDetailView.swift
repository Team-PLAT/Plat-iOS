//
//  UserDetailView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI
import Kingfisher

// MARK: - UserDetailView

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
        .tint(.white)
        .background(.platBackground)
    }
}

// MARK: - ProfileImageView

private struct ProfileImageView: View {
    
    @Environment(AuthUseCase.self) private var authUseCase
    
    @State private var isPhotoAlbumSheet = false
    @State private var selectedImage: UIImage?
    
    // TODO: 기본 이미지 추가
    private var profileImageUrl: URL? {
        URL(string: authUseCase.state.user?.profileImageUrl ?? "")
    }
    
    var body: some View {
        Button {
            isPhotoAlbumSheet.toggle()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                } else {
                    KFImage(profileImageUrl)
                        .placeholder {
                            Image(systemName: "")
                                .resizable()
                                .frame(width: 160, height: 160)
                                .background(.gray4)
                                .clipShape(Circle())
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                }
                
                CameraButton()
                    .padding(.trailing, -10)
                    .padding(.bottom, -5)
            }
        }
        .sheet(isPresented: $isPhotoAlbumSheet) {
            PhotoPicker(selectedImage: $selectedImage)
                .onChange(of: selectedImage) {
                    authUsecase.effect(.updateProfileAvatar(image: selectedImage))
                }
        }
        .onAppear {
            authUseCase.effect(.fetchProfile)
        }
    }
    
    private struct CameraButton: View {
        var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(.platBackground)
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
    
    @Environment(PathModel.self) private var pathModel
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(InfoUseCase.self) private var infoUseCase
    
    var nicknameInfo: ListSection.Info {
        return ListSection.Info(title: "닉네임") {
            pathModel.push(.nicknameSetting)
        }
    }
    
    var accountSettingsInfo: ListSection.Info {
        return ListSection.Info(title: "계정설정") {
            pathModel.push(.accountSetting)
        }
    }
    
    var aboutPlatInfo: ListSection.Info {
        return ListSection.Info(title: "About PLAT") {
            pathModel.push(.aboutPlatSettings)
        }
    }
    
    var supportInfo: ListSection.Info {
        .init(title: "지원", icon: .imgWeblink) {
            infoUseCase.checkSupport()
        }
    }
    
    var body: some View {
        VStack(spacing: 42) {
            ListSection(infoList: [nicknameInfo, accountSettingsInfo])
            ListSection(infoList: [aboutPlatInfo, supportInfo])
        }
    }
}

// MARK: - Preview

#Preview {
    UserDetailView()
        .injectDIContainer()
}
