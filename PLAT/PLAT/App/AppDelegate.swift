//
//  AppDelegate.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var onOpenURL: ((URL) -> Void)?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(#function)
        return true
    }
}
