//
//  SignUpOrInView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI
import AuthenticationServices

// MARK: - SignUpOrInView

struct SignUpOrInView: View {
    
    @Environment(AuthUseCase.self) private var authUseCase: AuthUseCase
    @Environment(InfoUseCase.self) private var infoUseCase: InfoUseCase
    
    @State private var isLoading = false
    @State private var isLoginFailedAlertPresented = false
    
    var body: some View {
        ZStack {
            if authUseCase.state.authType == .signUp {
                SignUpView(
                    isLoading: $isLoading,
                    isLoginFailedAlertPresented: $isLoginFailedAlertPresented
                )
            } else {
                SignInView(
                    isLoading: $isLoading,
                    isLoginFailedAlertPresented: $isLoginFailedAlertPresented
                )
            }
            
            if isLoading {
                PlatProgressView()
            }
        }
        .tint(.white)
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(authUseCase.state.authType == .signUp ? "회원가입" : "로그인" )
        .alert("일시적인 오류로 로그인에 실패했습니다. 다시 시도해주세요.", isPresented: $isLoginFailedAlertPresented) {
            Button("확인", role: .none) {}
        }
    }
}

// MARK: - SignUpView

private struct SignUpView: View {
    
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isLoginFailedAlertPresented: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("\(Constant.appName)에 오신 것을 \n환영해요")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 34)
                .padding(.top, 22)
                .padding(.trailing, 140)
                .lineSpacing(5)
            
            Spacer()
            
            Image(.imgHeadphone)
                .resizable()
                .frame(width: 270, height: 270)
                .padding(.bottom, 68)
            
            Spacer()
            
            AppleSignUpButton(
                isLoading: $isLoading,
                isLoginFailedAlertPresented: $isLoginFailedAlertPresented
            )
            
            PolicyNoticeText()
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
                .padding(.bottom, 4)
            
            SwitchSignInView()
            
        }
        .background(.black)
    }
}

// MARK: - AppleSignUpButton

private struct AppleSignUpButton: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isLoginFailedAlertPresented: Bool
    
    var body: some View {
        SignInWithAppleButton(
            .signUp,
            onRequest: { _ in authUseCase.requestSocialLogin() },
            onCompletion: { appleLoginCompletion($0) }
        )
        .signInWithAppleButtonStyle(.white)
        .frame(height: 54)
        .cornerRadius(8)
        .padding(.horizontal, 18)
    }
    
    /// 애플 로그인이 완료 된 후 호출되는 Completion 함수입니다.
    private func appleLoginCompletion(_ result: Result<ASAuthorization, any Error>) {
        let loginResult = authUseCase.handleSocialLogin(authResult: result)
        switch loginResult {
        case .success: signIn()
        case .failure(let error): print(error)
        }
    }
    
    /// 로그인을 요청합니다.
    private func signIn() {
        Task {
            isLoading = true
            let result = await authUseCase.signIn(socialAccount: .apple)
            switch result {
            case .success: pathModel.push(.selectStreamAccount)
            case .failure: isLoginFailedAlertPresented.toggle()
            }
            isLoading = false
        }
    }
}

// MARK: - PolicyNoticeText

private struct PolicyNoticeText: View {
    
    @Environment(InfoUseCase.self) private var infoUseCase
    
    var body: some View {
        HStack(spacing: 0) {
            Text("위의 버튼을 누름으로써, ")
            Text("개인정보보호정책 ")
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white), alignment: .bottom)
                .onTapGesture {
                    infoUseCase.checkPrivacyPolicy()
                }
            Text("및")
        }
        .font(.Body.body4)
        .foregroundColor(.white)
        
        HStack(spacing: 0) {
            Text("서비스 이용약관")
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white), alignment: .bottom)
                .onTapGesture {
                    infoUseCase.checkTermsOfService()
                }
            
            Text("에 동의하는 것입니다.")
        }
        .font(.Body.body4)
        .foregroundColor(.white)
    }
}

// MARK: - SwitchSignInView

private struct SwitchSignInView: View {
    
    @Environment(AuthUseCase.self) private var authUseCase: AuthUseCase
    
    var body: some View {
        HStack(spacing: 5) {
            Text("이미 계정이 있으신가요?")
                .font(.Body.body4)
                .foregroundColor(.white)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 0.8, height: 15)
                .background(.white)
            
            Text("로그인하기")
                .font(.Body.body4)
                .foregroundColor(.platPurple)
                .onTapGesture {
                    authUseCase.effect(.toggleAuthType(.signIn))
                }
        }
    }
}

// MARK: - SignInView

private struct SignInView: View {
    
    @Environment(AuthUseCase.self) private var authUseCase: AuthUseCase
    
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isLoginFailedAlertPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("또 다시,\nLet's \(Constant.appName)!")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 30)
                .padding(.top, 18)
                .padding(.trailing, 206)
                .lineSpacing(5)
            
            Spacer()
            
            LottieAnimationView(lottieName: Lottie.finger, lottieSpeed: 1.5)
            
            Spacer()
            
            AppleContinueButton(
                isLoading: $isLoading,
                isLoginFailedAlertPresented: $isLoginFailedAlertPresented
            )
            .padding(.bottom, 62)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
            
            SwitchSignUpView()
        }
        .background(.black)
    }
}

// MARK: - AppleContinueButton

struct AppleContinueButton: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    
    @Binding private(set) var isLoading: Bool
    @Binding private(set) var isLoginFailedAlertPresented: Bool
    
    var body: some View {
        SignInWithAppleButton(
            .continue,
            onRequest: { _ in authUseCase.requestSocialLogin() },
            onCompletion: { appleLoginCompletion($0) }
        )
        .signInWithAppleButtonStyle(.white)
        .frame(height: 54)
        .cornerRadius(8)
        .padding(.horizontal, 18)
    }
    
    /// 애플 로그인이 완료 된 후 호출되는 Completion 함수입니다.
    private func appleLoginCompletion(_ result: Result<ASAuthorization, any Error>) {
        let loginResult = authUseCase.handleSocialLogin(authResult: result)
        switch loginResult {
        case .success: signIn()
        case .failure(let error): print(error)
        }
    }
    
    /// 로그인을 요청합니다.
    private func signIn() {
        Task {
            isLoading = true
            let result = await authUseCase.signIn(socialAccount: .apple)
            switch result {
            case .success: pathModel.push(.selectStreamAccount)
            case .failure: isLoginFailedAlertPresented.toggle()
            }
            isLoading = false
        }
    }
}

// MARK: - SwitchSignUpView

private struct SwitchSignUpView: View {
    @Environment(AuthUseCase.self) private var authUseCase
    
    var body: some View {
        HStack(spacing: 5) {
            Text("새로 가입하시나요?")
                .font(.Body.body4)
                .foregroundColor(.white)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 1, height: 15)
                .background(.white)
            
            Text("회원가입하기")
                .font(.Body.body4)
                .foregroundColor(.platPurple)
                .onTapGesture {
                    authUseCase.effect(.toggleAuthType(.signUp))
                }
        }
    }
}

// MARK: - Preview

#Preview {
    SignUpOrInView()
        .environment(PreviewHelper.mockAuthUseCase)
        .environment(PreviewHelper.mockInfoUseCase)
}
