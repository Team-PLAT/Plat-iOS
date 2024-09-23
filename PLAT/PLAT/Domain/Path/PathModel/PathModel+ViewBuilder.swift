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
            
        case .appendPlaylistView:
            AppendPlaylistView()
            
        case .playlistDetail:
            PlaylistDetailView()
            
        case .playlistDetailsEditView:
            PlaylistDetailsEditView()
            
        case .userDetail:
            UserDetailView()
            
        case .nicknameSetting:
            NicknameSettingsView()
            
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
        case .whyConnectStreamAccount:
            WhyConnectStreamAccountSheet()
            
        case .trackAppendToPlaylist:
            TrackAppendToPlaylistSheet()
            
        case .trackAppendSearch:
            TrackAppendSearchSheet()
            
        case .trackAppendContent:
            TrackAppendContentSheet()
            
        case .playlistDetail:
            EmptyView()
        
        case .playlistInfo:
            EmptyView()
        
        case .appendPlaylist:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .trackDetail:
            TrackDetailFullScreen()
            
        case .platProcessing:
            PlatProcessingFullScreen(playList: .constant(MockDataBuilder.playlist))
        }
    }
}
