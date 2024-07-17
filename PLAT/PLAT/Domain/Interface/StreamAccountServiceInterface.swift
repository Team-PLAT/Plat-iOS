//
//  StreamAccountServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import MusicKit

protocol StreamAccountServiceInterface {
    func connect(streamAccount: StreamAccount)
    func requestAppleMusic() async -> Bool
//    func fetchAppleMusicSubscription(musicsubscription: MusicSubscription) async
}
