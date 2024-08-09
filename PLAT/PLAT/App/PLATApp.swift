//
//  PLATApp.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

@main
struct PLATApp: App {
    @StateObject private var viewModel = SpotifyViewModel()
    
    var body: some Scene {
        WindowGroup {
            //          OnboardingView()
            SpotifyView()
                .environmentObject(viewModel)
                .onOpenURL { url in
                    print("App received URL: \(url)")
                    viewModel.handleURL(url: url)
                }
        }
    }
}
