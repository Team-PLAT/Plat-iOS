//
//  MainView.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                Group {
                    switch tab {
                    case .map: Text("MapView")
                    case .feed:
                        Text("FeedView")
                    case .playlist:
                        Text("PlaylistView")
                    case .account:
                        UserDetailView(userUseCase: UserUseCase(userService: StubUserService()))
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
}

#Preview {
    MainView()
}
