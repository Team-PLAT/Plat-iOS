//
//  OnboardingView.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    
    var body: some View {
        VStack {
            
            Image("plat")
                .resizable()
                .frame(height: 20)
                .padding(.top, 32)
                .padding(.horizontal, 162)
                .padding(.bottom, 24)
            
            Text("Place에 맞는 음악을,\nPLAT으로\nPLAY.", targetString: "PLAT", targetFont: Font.custom("Pretendard-ExtraBold", size: 34))
                .font(Font.custom("Pretendard-Regular", size: 34))
                .padding(.leading, 24)
                .padding(.trailing, 82)
            
            LottieAnimationView(lottieName: "plat_map_animation_lottie", lottieSpeed: 3)
            
            ActionButton(state: .enabled, title: "시작하기") {
                print("시작하기")
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 22)
            
            LoginButton()
                .font(.Head.head4)
                .foregroundStyle(.platPurple)
                .padding(.bottom, 30)
        }
    }
}

// MARK: - LoginButton
private struct LoginButton: View {
    
    var body: some View {
        Button(action: {
            print("로그인하기")
        }, label: {
            Text("로그인")
        })
    }
}

// MARK: - LottieAnimationView
private struct LottieAnimationView: View {
    
    let lottieName: String
    let lottieSpeed: Double
    
    var body: some View {
        LottieView(animation: .named(lottieName))
            .looping()
            .animationSpeed(lottieSpeed)
    }
}

// MARK: - Text extension
extension Text {
    
    init(_ textString: String, targetString: String, targetFont: Font) {
        
        var attributedString: AttributedString {

            var attributedString = AttributedString(textString)
            
            if let target = attributedString.range(of: targetString) {
                attributedString[target].font = targetFont
            }
            
            return attributedString
        }
        
        self.init(attributedString)
    }

}

#Preview {
    OnboardingView()
}
