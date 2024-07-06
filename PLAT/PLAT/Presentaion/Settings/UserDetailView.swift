//
//  UserDetailView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct UserDetailView: View {
    
    @State private(set) var userUseCase: UserUseCase
    
    var body: some View {
        NavigationStack {
            VStack {
                ProfileImageView()
                Spacer()
            }
            .navigationTitle("내 계정")
            .navigationBarTitleDisplayMode(.inline)
            .background(.platBlack)
        }
        .ignoresSafeArea()
        .environment(userUseCase)
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

#Preview {
    UserDetailView(userUseCase: UserUseCase(userService: StubUserService()))
}
