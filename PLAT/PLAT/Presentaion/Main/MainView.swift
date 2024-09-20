//
//  MainView.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var pathModel: PathModel = .init()
    @State private var infoUseCase: InfoUseCase = .init(infoService: StubInfoService())
    @State private var userUseCase: UserUseCase = .init(userProfileService: StubUserProfileService())
    @State private var streamAccountUseCase: StreamAccountUseCase = .init(streamAccountService: StubStreamAccountService())
    @State private var trackUseCase: TrackUseCase = .init(
        trackService: TrackServiceImpl(),
        imageService: ImageServiceImpl()
    )
    @State private var trackMapUseCase: TrackMapUseCase = .init(mapService: StubTrackMapService())
    @State private var musicControlUseCase = MusicControlUseCase(
        musicController: AppleMusicController.shared
    )
    @State private var playlistUseCase: PlaylistUseCase = .init(playlistService: StubPlaylistService())
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            TabView(selection: $selectedTab) {
                TrackMapView()
                    .modifier(ConfigureTab(selectedTab: .map))
                
                TrackFeedView()
                    .modifier(ConfigureTab(selectedTab: .feed))
                
                PlaylistView()
                    .modifier(ConfigureTab(selectedTab: .playlist))
                
                UserDetailView()
                    .modifier(ConfigureTab(selectedTab: .account))
            }
            .tint(.platPurple)
            .navigationDestination(for: SettingPath.self) { path in
                switch path {
                case .nicknameSettingsView:
                    NicknameSettingsView(nicknameText: "")
                        .toolbarRole(.editor)
                case .accountSettingsView:
                    AccountSettingsView()
                        .toolbarRole(.editor)
                case .aboutPlatSettingsView:
                    AboutPlatSettingsView()
                        .toolbarRole(.editor)
                case .streamAccountSettingsView:
                    StreamAccountSettingsView()
                        .toolbarRole(.editor)
                }
            }
        }
        .environment(pathModel)
        .environment(userUseCase)
        .environment(infoUseCase)
        .environment(streamAccountUseCase)
        .environment(trackUseCase)
        .environment(trackMapUseCase)
        .environment(musicControlUseCase)
        .environment(playlistUseCase)
    }
    
    /// Tab 설정을 위한 Custom Modifier
    private struct ConfigureTab: ViewModifier {
        
        let selectedTab: Tab
        
        func body(content: Content) -> some View {
            content
                .tag(selectedTab)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab.icon)
                        
                        Text(selectedTab.title)
                            .font(.Caption.caption2)
                    }
                }
        }
    }
}

private struct AView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("하잉")
                Spacer()
            }
            Spacer()
        }
        .background(.green)
    }
}

#Preview {
    MainView()
}
