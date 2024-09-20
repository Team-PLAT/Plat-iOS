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
        if !authUseCase.state.isLoginComplete {
            PlatMainView()
        } else {
            LoginView()
        }
    }
}

// MARK: - PlatMainView

private struct PlatMainView: View {
    
    @Environment(PathModel.self) private var pathModel
    
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        @Bindable var pathModel = pathModel
        NavigationStack(path: $pathModel.path) {
            TabView(selection: $selectedTab) {
                pathModel.build(.trackMap)
                    .modifier(ConfigureTabModifier(selectedTab: .map))
                
                pathModel.build(.trackFeed)
                    .modifier(ConfigureTabModifier(selectedTab: .feed))
                
                pathModel.build(.playlist)
                    .modifier(ConfigureTabModifier(selectedTab: .playlist))
                
                pathModel.build(.userDetail)
                    .modifier(ConfigureTabModifier(selectedTab: .account))
            }
            .tint(.platPurple)
            .navigationDestination(for: Screen.self) { screen in
                pathModel.build(screen)
            }
            .sheet(item: $pathModel.sheet) { sheet in
                pathModel.build(sheet)
            }
            .fullScreenCover(item: $pathModel.fullScreenCover) { fullScreen in
                pathModel.build(fullScreen)
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

// MARK: - ConfigureTabModifier

/// Tab 설정을 위한 Custom Modifier
private struct ConfigureTabModifier: ViewModifier {
    
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

// MARK: - Preview

#Preview {
    AppCoordinatorView()
}
