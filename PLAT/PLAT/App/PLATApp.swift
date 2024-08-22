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
    
    @State private var musicControlUseCase = MusicControlUseCase(
        musicController: AppleMusicController.shared
    )
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
        .environment(musicControlUseCase)
    }
}
