//
//  LoginView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI
import AuthenticationServices

enum AuthType {
    case signIn
    case signUp
}

// MARK: - SignUpView
struct SignUpView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 28)
            
            Text("PLAT에 오신 것을 \n환영해요")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 34)
                .padding(.trailing, 158)
            
            Image("headphone")
                .resizable()
                .frame(width: 270, height: 270)
                .padding(.bottom, 68)
            
            
            AppleSignUpButton()
            
            PolicyNoticeText()
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
                .padding(.bottom, 4)
            
            SwitchSignInView()
            
        }.background(.black)
    }
}

struct PolicyNoticeText: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("위의 버튼을 누름으로써, ")
            Text("개인정보보호정책 ")
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white), alignment: .bottom)
            Text("및")
        }.font(.Body.body4)
            .foregroundColor(.white)
        
        HStack(spacing: 0) {
            Text("서비스 이용약관")
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white), alignment: .bottom)
            
            Text("에 동의하는 것입니다.")
        }.font(.Body.body4)
            .foregroundColor(.white)
    }
}

struct AppleSignUpButton: View {
    var body: some View {
        SignInWithAppleButton(
            .signUp,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    }
                case .failure:
                    print("Apple ID 로그인 실패")
                }
            }
        ).signInWithAppleButtonStyle(.white)
            .frame(width: 358, height: 54)
            .cornerRadius(8)
    }
}

struct SwitchSignInView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("이미 계정이 있으신가요?")
                .font(.Body.body4)
                .foregroundColor(.white)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 0.8, height: 15)
                .background(.white)
            
            Text("로그인하기") // AuthType 변경
                .font(.Body.body4)
                .foregroundColor(.platPurple)
        }
    }
}

// MARK: - SignInView
struct SignInView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 24)
            
            Text("또 다시,\nLet's PLAT!")
                .font(.Head.head1)
                .foregroundColor(.white)
                .padding(.bottom, 30)
                .padding(.trailing, 222)
            
            Image("")
                .frame(width: 270, height: 270)
                .padding(.bottom, 82)
            
            AppleContinueButton()
                .padding(.bottom, 62)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 316, height: 1)
                .background(.white)
            
            SwitchSignUpView()
        }.background(.black)
    }
}

struct AppleContinueButton: View {
    var body: some View {
        SignInWithAppleButton(
            .continue,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    }
                case .failure:
                    print("Apple ID 로그인 실패")
                }
            }
        ).signInWithAppleButtonStyle(.white)
            .frame(width: 357, height: 54)
            .cornerRadius(10)
    }
}

struct SwitchSignUpView: View {
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
        }
    }
}

struct LoginView: View {
    @State private var authType: AuthType = .signUp
    
    var body: some View {
        NavigationStack {
            if authType == .signUp {
                SignUpView()
            } else {
                SignInView()
            }
        }
        .navigationTitle(authType == .signUp ? "회원가입" : "로그인" ) //navigation 정리할 때 이전 뷰에서 처리
        .navigationBarTitleDisplayMode(.inline)
        .tint(.white)
    }
}

#Preview {
    LoginView()
}
