//
//  StreamAccount.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

enum StreamAccount {
    case appleMusic
    case spotify
    
    var icon: ImageResource {
        switch self {
        case .appleMusic: return .appleMusic
        case .spotify: return .spotify
        }
    }
}
