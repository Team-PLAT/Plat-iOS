//
//  AppCoordinatorView.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import SwiftUI

// MARK: - AppCoordinatorView

struct AppCoordinatorView: View {
    
    @Environment(AuthUseCase.self) private var authUseCase
    
    var body: some View {
        if authUseCase.state.isLoginComplete {
            PlatMainView()
        } else {
            LoginView()
        }
    }
}

// MARK: - PlatMainView

private struct PlatMainView: View {
    
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        @Bindable var pathModel = pathModel
        NavigationStack(path: $pathModel.path) {
            pathModel.build(.trackMap)
                .navigationDestination(for: Screen.self) { screen in
                    pathModel.build(screen)
                }
        }
    }
}

// MARK: - LoginView

private struct LoginView: View {
    
    @Environment(PathModel.self) private var pathModel
    
    var body: some View {
        @Bindable var pathModel = pathModel
        NavigationStack(path: $pathModel.path) {
            pathModel.build(.onboarding)
                .navigationDestination(for: Screen.self) { screen in
                    pathModel.build(screen)
                }
                .sheet(item: $pathModel.sheet) { sheet in
                    pathModel.build(sheet)
                }
        }
    }
}

//struct MainView: View {
//
//    @State private var pathModel: PathModel = .init()
//    @State private var infoUseCase: InfoUseCase = .init(infoService: StubInfoService())
//    @State private var userUseCase: UserUseCase = .init(userProfileService: StubUserProfileService())
//    @State private var streamAccountUseCase: StreamAccountUseCase = .init(streamAccountService: StubStreamAccountService())
//    @State private var trackUseCase: TrackUseCase = .init(
//        trackService: TrackServiceImpl(),
//        imageService: ImageServiceImpl()
//    )
//    @State private var trackMapUseCase: TrackMapUseCase = .init(mapService: StubTrackMapService())
//    @State private var musicControlUseCase = MusicControlUseCase(
//        musicController: AppleMusicController.shared
//    )
//    @State private var playlistUseCase: PlaylistUseCase = .init(playlistService: StubPlaylistService())
//    @State private var selectedTab: Tab = .map
//
//    var body: some View {
//        NavigationStack(path: $pathModel.paths) {
//            TabView(selection: $selectedTab) {
//                TrackMapView()
//                    .modifier(ConfigureTab(selectedTab: .map))
//
//                TrackFeedView()
//                    .modifier(ConfigureTab(selectedTab: .feed))
//
//                PlaylistView()
//                    .modifier(ConfigureTab(selectedTab: .playlist))
//
//                UserDetailView()
//                    .modifier(ConfigureTab(selectedTab: .account))
//            }
//            .tint(.platPurple)
//            .navigationDestination(for: SettingPath.self) { path in
//                switch path {
//                case .nicknameSettingsView:
//                    NicknameSettingsView(nicknameText: "")
//                        .toolbarRole(.editor)
//                case .accountSettingsView:
//                    AccountSettingsView()
//                        .toolbarRole(.editor)
//                case .aboutPlatSettingsView:
//                    AboutPlatSettingsView()
//                        .toolbarRole(.editor)
//                case .streamAccountSettingsView:
//                    StreamAccountSettingsView()
//                        .toolbarRole(.editor)
//                }
//            }
//        }
//        .environment(pathModel)
//        .environment(userUseCase)
//        .environment(infoUseCase)
//        .environment(streamAccountUseCase)
//        .environment(trackUseCase)
//        .environment(trackMapUseCase)
//        .environment(musicControlUseCase)
//        .environment(playlistUseCase)
//    }
//
//    /// Tab 설정을 위한 Custom Modifier
//    private struct ConfigureTab: ViewModifier {
//
//        let selectedTab: Tab
//
//        func body(content: Content) -> some View {
//            content
//                .tag(selectedTab)
//                .tabItem {
//                    VStack {
//                        Image(systemName: selectedTab.icon)
//
//                        Text(selectedTab.title)
//                            .font(.Caption.caption2)
//                    }
//                }
//        }
//    }
//}

// MARK: - Preview

#Preview {
    AppCoordinatorView()
}
