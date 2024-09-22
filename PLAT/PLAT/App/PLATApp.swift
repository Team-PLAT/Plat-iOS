//
//  PLATApp.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

@main
struct PLATApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .injectDIContainer()
        }
    }
}
