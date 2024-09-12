//
//  OnboardingView.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    
    @State private var musicControlUseCase = MusicControlUseCase(
        musicController: AppleMusicController.shared
    )
    
    @State private var infoUseCase: InfoUseCase = .init(infoService: StubInfoService())
    @State private var authType: AuthType = .signUp
    
    var body: some View {
        @Bindable var pathModel = pathModel
        NavigationStack(path: $pathModel.registerPaths) {
            VStack(spacing: 0) {
                Image(.imgPlat)
                    .resizable()
                    .frame(height: 20)
                    .padding(.top, 32)
                    .padding(.horizontal, 162)
                
                HStack {
                    Text("Place에 맞는 음악을,\nPLAT으로\nPLAY.", targetString: "PLAT", targetFont: .CustomTitle.customTitle1)
                        .foregroundStyle(.white)
                        .font(.CustomTitle.customTitle2)
                        .padding(.top, 22)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                LottieAnimationView(
                    lottieName: Lottie.map,
                    lottieSpeed: 3
                )
                
                ActionButton(state: .enabled, title: "시작하기") {
                    self.authType = .signUp
                    pathModel.registerPaths.append(.loginView)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
                
                LoginButton(authType: $authType)
                    .font(.Head.head5)
                    .foregroundStyle(.platPurple)
                    .padding(.bottom, 30)
                
            }
            .background(.black)
            .navigationDestination(for: RegisterPath.self) { path in
                switch path {
                case .loginView:
                    LoginView(authType: $authType)
                        .navigationTitle(authType == .signUp ? "회원가입" : "로그인" )
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarRole(.editor)
                        .tint(.white)
                case .selectStreamAccountView:
                    SelectStreamAccountView()
                        .navigationTitle("스트리밍 계정 선택하기")
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .environment(pathModel)
        .environment(authUseCase)
        .environment(infoUseCase)
        .environment(musicControlUseCase)
    }
}

// MARK: - LoginButton

private struct LoginButton: View {
    @Environment(PathModel.self) private var pathModel
    @Binding var authType: AuthType
    
    var body: some View {
        Button {
            self.authType = .signIn
            pathModel.registerPaths.append(.loginView)
        } label: {
            Text("로그인")
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
