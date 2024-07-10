//
//  StreamAccount.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

enum StreamAccount: String {
    case appleMusic = "Apple Music"
    case spotify = "Spotify"
    
    var icon: ImageResource {
        switch self {
        case .appleMusic: return .appleMusic
        case .spotify: return .spotify
        }
    }
}
