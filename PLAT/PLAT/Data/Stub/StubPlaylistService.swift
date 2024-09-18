//
//  StubPlaylistService.swift
//  PLAT
//
//  Created by 조우현 on 9/17/24.
//

import Foundation

struct StubPlaylistService: PlaylistServiceInterface {
    func playOnDevice() {
        print(#function)
    }
    
    func deletePlaylist() {
        print(#function)
    }
}
