//
//  MainView.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var infoUseCase: InfoUseCase = .init(infoService: StubInfoService())
    @State private var userUseCase: UserUseCase = .init(userService: StubUserService())
    @State private var streamAccountUseCase: StreamAccountUseCase = .init(streamAccountService: StubStreamAccountService())
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ForEach(Tab.allCases) { tab in
                    Group {
                        switch tab {
                        case .map: Text("MapView")
                        case .feed: Text("FeedView")
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
        }
        .environment(userUseCase)
        .environment(infoUseCase)
        .environment(streamAccountUseCase)
    }
}

#Preview {
    MainView()
}
