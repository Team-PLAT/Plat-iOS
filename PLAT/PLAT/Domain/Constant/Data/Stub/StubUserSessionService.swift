//
//  StubUserSessionService.swift
//  PLAT
//
//  Created by 조우현 on 8/22/24.
//

import Foundation

struct StubUserSessionService: UserSessionServiceInterface {
    func logout() {
        print(#function)
    }
    
    func deleteAccount() {
        print(#function)
    }
}
