//
//  OnboardingView.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.imgPlat)
                .resizable()
                .frame(height: 20)
                .padding(.top, 32)
                .padding(.horizontal, 162)
            
            HStack {
                Text(
                    "Place에 맞는 음악을,\n\(Constant.appName)으로\nPLAY.",
                    targetString: Constant.appName,
                    targetFont: .CustomTitle.customTitle1
                )
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
                authUseCase.effect(.toggleAuthType(.signUp))
                pathModel.push(.signUpOrIn)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 22)
            
            LoginButton()
                .font(.Head.head5)
                .foregroundStyle(.platPurple)
                .padding(.bottom, 30)
            
        }
        .background(.black)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - LoginButton

private struct LoginButton: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    
    var body: some View {
        Button {
            authUseCase.effect(.toggleAuthType(.signIn))
            pathModel.push(.signUpOrIn)
        } label: {
            Text("로그인")
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
