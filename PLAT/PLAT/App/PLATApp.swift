//
//  PLATApp.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

@main
struct PLATApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var pathModel: PathModel = .init()
    
    @State private var authUseCase: AuthUseCase = .init(
        socialLoginServcie: AppleSocialLoginService(),
        memberService: MemberServiceImpl()
    )
    
    var body: some Scene {
        WindowGroup {
            if authUseCase.state.isLoginComplete {
                OnboardingView()
            } else {
                MainView()
            }
        }
        .environment(pathModel)
        .environment(authUseCase)
    }
}
