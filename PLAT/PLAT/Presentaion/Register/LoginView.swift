//
//  LoginView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(LoginUseCase.self) private var loginUseCase: LoginUseCase
    @Environment(InfoUseCase.self) private var infoUseCase: InfoUseCase
    
    @State private var authType: AuthType = .signUp
    
    var body: some View {
        NavigationStack {
            if authType == .signUp {
                SignUpView(authType: $authType)
            } else {
                SignInView(authType: $authType)
            }
        }
        .navigationTitle(authType == .signUp ? "회원가입" : "로그인" )
        .navigationBarTitleDisplayMode(.inline)
        .tint(.white)
    }
}

// MARK: - SignUpView
private struct SignUpView: View {
    @Binding var authType: AuthType
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 28)
            
            Text("PLAT에 오신 것을 \n환영해요")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 34)
                .padding(.trailing, 158)
                .lineSpacing(5)
            
            Spacer()
            
            Image(.headphone)
                .resizable()
                .frame(width: 270, height: 270)
                .padding(.bottom, 68)
            
            Spacer()
            
            AppleSignUpButton()
            
            PolicyNoticeText()
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
                .padding(.bottom, 4)
            
            SwitchSignInView(authType: $authType)
            
        }.background(.platBackground)
    }
}

private struct AppleSignUpButton: View {
    @Environment(LoginUseCase.self) private var loginUseCase
    
    var body: some View {
        SignInWithAppleButton(
            .signUp,
            onRequest: { _ in loginUseCase.requestLogin()},
            onCompletion: { result in
                let loginResult = loginUseCase.handleLogin(authResult: result)
                switch loginResult {
                case .success:
                    print("로그인 성공")
                    // 다음 뷰로 이동
                    
                case .failure(let error):
                    print("로그인 실패 \(error.localizedDescription)")
                }
            }
        ).signInWithAppleButtonStyle(.white)
            .frame(height: 54)
            .cornerRadius(8)
            .padding(.horizontal, 18)
    }
}

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
        }.font(.Body.body4)
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
        }.font(.Body.body4)
            .foregroundColor(.white)
    }
}

private struct SwitchSignInView: View {
    @Binding var authType: AuthType
    
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
                    self.authType = .signIn
            }
        }
    }
}

// MARK: - SignInView
private struct SignInView: View {
    @Binding var authType: AuthType
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 24)
            
            Text("또 다시,\nLet's PLAT!")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 30)
                .padding(.trailing, 222)
                .lineSpacing(5)
            
            Image("")
                .frame(width: 270, height: 270)
                .padding(.bottom, 82)
            
            Spacer()
            
            AppleContinueButton()
                .padding(.bottom, 62)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
            
            SwitchSignUpView(authType: $authType)
        }.background(.platBackground)
    }
}

struct AppleContinueButton: View {
    @Environment(LoginUseCase.self) private var loginUseCase
    
    var body: some View {
        SignInWithAppleButton(
            .continue,
            onRequest: { _ in loginUseCase.requestLogin()},
            onCompletion: { result in
                let loginResult = loginUseCase.handleLogin(authResult: result)
                switch loginResult {
                case .success:
                    print("로그인 성공")
                    // 다음 뷰로 이동
                    
                case .failure(let error):
                    print("로그인 실패 \(error.localizedDescription)")
                }
            }
        ).signInWithAppleButtonStyle(.white)
            .frame(height: 54)
            .cornerRadius(8)
            .padding(.horizontal, 18)
    }
}

private struct SwitchSignUpView: View {
    @Binding var authType: AuthType
    
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
                    self.authType = .signUp
                }
        }
    }
}

#Preview {
    LoginView()
        .environment(PreviewHelper.mockLoginUseCase)
        .environment(PreviewHelper.mockInfoUseCase)
    
}
