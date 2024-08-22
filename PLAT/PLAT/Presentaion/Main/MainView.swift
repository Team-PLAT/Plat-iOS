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
    @State private var trackMapUseCase: TrackMapUseCase = .init(trackMapService: StubTrackMapService())
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            TabView(selection: $selectedTab) {
                ForEach(Tab.allCases) { tab in
                    Group {
                        switch tab {
                        case .map: TrackMapView()
                        case .feed: FeedView()
                        case .playlist: Text("PlaylistView")
                        case .account: UserDetailView()
                        }
                    }
                    .tag(tab)
                    .tabItem {
                        VStack {
                            Image(systemName: tab.icon)
                            Text(tab.title)
                                .font(.Caption.caption2)
                        }
                    }
                }
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
        .environment(trackMapUseCase)
    }
}

#Preview {
    MainView()
}
