//
//  PLATApp.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

@main
struct PLATApp: App {
    
    @State private var authUseCase: AuthUseCase = .init(authService: AppleLoginService(), userSessionService: StubUserSessionService())
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
        .environment(authUseCase)
    }
}
