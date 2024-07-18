//
//  OnboardingView.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var loginUseCase: LoginUseCase = .init(loginService: LoginService())
    @State private var infoUseCase: InfoUseCase = .init(infoService: StubInfoService())
    
    @State private var pathModel: PathModel = .init()
    @State private var authType: AuthType = .signUp
    
    var body: some View {
        NavigationStack(path: $pathModel.registerPaths) {
            VStack {
                Image(.imgPlat)
                    .resizable()
                    .frame(height: 20)
                    .padding(.top, 32)
                    .padding(.horizontal, 162)
                    .padding(.bottom, 24)
                
                Text("Place에 맞는 음악을,\nPLAT으로\nPLAY.", targetString: "PLAT", targetFont: .Title.title1)
                    .foregroundStyle(.white)
                    .font(.Title.title2)
                    .padding(.leading, 24)
                    .padding(.trailing, 82)
                
                LottieAnimationView(lottieName: Lottie.map, lottieSpeed: 3)
                
                ActionButton(state: .enabled, title: "시작하기") {
                    self.authType = .signUp
                    pathModel.registerPaths.append(.loginView)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
                
                LoginButton(authType: $authType)
                    .font(.Head.head4)
                    .foregroundStyle(.platPurple)
                    .padding(.bottom, 30)
                
            }.background(.black)
                .navigationDestination(for: RegisterPath.self) { path in
                    switch path {
                    case .loginView:
                        LoginView(authType: $authType)
                            .navigationTitle(authType == .signUp ? "회원가입" : "로그인" )
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbarRole(.editor)
                            .tint(.white)
                            .environment(loginUseCase)
                            .environment(infoUseCase)
                    case .selectStreamAccountView:
                        SelectStreamAccountView()
                            .navigationTitle("스트리밍 계정 선택하기")
                            .navigationBarBackButtonHidden()
                    }
                }
        } .environment(pathModel)
    }
}

// MARK: - LoginButton

private struct LoginButton: View {
    @Environment(PathModel.self) var pathModel
    @Binding var authType: AuthType
    
    var body: some View {
        Button(action: {
            self.authType = .signIn
            pathModel.registerPaths.append(.loginView)
        }, label: {
            Text("로그인")
        })
    }
}

#Preview {
    OnboardingView()
}
