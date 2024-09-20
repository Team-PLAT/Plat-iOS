//
//  PathModel+ViewBuilder.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import SwiftUI

extension PathModel {
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .onboarding:
            OnboardingView()
            
        case .signUpOrIn:
            SignUpOrInView()
            
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
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .whyConnectStreamAccountSheet:
            WhyConnectStreamAccountSheet()
        case .trackAppendToPlaylistSheet:
            TrackAppendToPlaylistSheet()
            
        default: EmptyView()
//        case .trackAppend:
//            <#code#>
//        case .playlistDetail:
//            <#code#>
//        case .playlistInfo:
//            <#code#>
//        case .appendPlaylist:
//            <#code#>
        }
    }
}
