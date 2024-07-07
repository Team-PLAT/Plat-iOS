//
//  StubStreamAccountService.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import Foundation

struct StubStreamAccountService: StreamAccountServiceInterface {
    func connect(streamAccount: StreamAccount) {
        print(#function)
    }
}
