//
//  Path.swift
//  PLAT
//
//  Created by 조우현 on 7/12/24.
//

import Foundation

enum Path: Hashable {
    case nicknameSettingsView
    case accountSettingsView
    case streamAccountSettingsView
    case aboutPlatSettingsView
}

@Observable
final class PathModel {
    var paths: [Path] = []
}
