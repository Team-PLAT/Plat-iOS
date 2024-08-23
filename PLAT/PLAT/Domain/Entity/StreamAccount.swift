//
//  StreamAccount.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

enum StreamAccount: String {
    case appleMusic = "Apple Music"
    
    var icon: ImageResource {
        switch self {
        case .appleMusic: return .icnAppleMusic
        }
    }
}
