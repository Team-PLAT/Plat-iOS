//
//  PLATApp.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

@main
struct PLATApp: App {
    
    @State private var loginUseCase: LoginUseCase = .init(loginService: LoginService())
    
    var body: some Scene {
        WindowGroup {
//            MainView()
            LoginView()
                .environment(loginUseCase)
        }
    }
}
