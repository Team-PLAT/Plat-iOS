//
//  AppCoordinationImpl+ViewBuilder.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import SwiftUI

extension AppCoordinationImpl {
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .onboarding:
            OnboardingView()
            
        case .login:
            LoginView()
            
        case .selectStreamAccount:
            SelectStreamAccountView()
            
        case .trackMap:
            TrackMapView()
            
        case .trackFeed:
            TrackFeedView()
            
        case .playlist:
            PlaylistView()
            
        case .playlistDetail:
            PlaylistDetailView()
            
        case .userDetail:
            UserDetailView()
            
        case .nicknameSetting(let nickname):
            NicknameSettingsView(nicknameText: nickname)
            
        case .accountSetting:
            AccountSettingsView()
            
        case .streamAccountSetting:
            StreamAccountSettingsView()
            
        case .aboutPlatSettings:
            AboutPlatSettingsView()
        }
    }
}
