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
    
    // TODO: 추후 스트리밍 계정 선택할 때 주입해주기
    @State private var musicControlUseCase = MusicControlUseCase(
        musicController: StubMusicController()
    )
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
        .environment(musicControlUseCase)
    }
}
