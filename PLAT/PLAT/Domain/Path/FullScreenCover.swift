//
//  FullScreenCover.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import Foundation

enum FullScreenCover: Identifiable, Hashable {
    
    // 트랙
    case trackDetail
    case platProcessing
    
    var id: Self { self }
}
