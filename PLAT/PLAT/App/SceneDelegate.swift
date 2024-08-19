//
//  SceneDelegate.swift
//  PLAT
//
//  Created by 김민준 on 8/18/24.
//

import UIKit

// MARK: - SceneDelegate

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
}

// MARK: - Handle Spotify Deep Link

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SpotifyMusicController.shared.setAccessToken(from: url)
    }
}
