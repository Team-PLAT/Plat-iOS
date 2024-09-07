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
        authService: AppleSocialLoginService(),
        userSessionService: StubUserSessionService() // TODO: Stub 교체
    )
    
    struct ProfileResponse: Decodable {
        let memberId: Int64
        let nickname: String
        let avatar: String
    }
    
    var body: some Scene {
        WindowGroup {
            if !authUseCase.state.isLoginComplete {
                OnboardingView()
                    .onAppear {
                        Task {
                            let response: Result<BaseResponse<ProfileResponse>, Error> =  await NetworkClient().get(url: APIs.Plat.Members.fetchProfile.url
                            )
                        }
                    }
            } else {
                MainView()
            }
        }
        .environment(pathModel)
        .environment(authUseCase)
    }
}
