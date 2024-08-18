//
//  Helper+Preview.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import Foundation

enum PreviewHelper {
    static let mockUserUseCase = UserUseCase(userService: StubUserService())
    static let mockInfoUseCase = InfoUseCase(infoService: StubInfoService())
    static let mockStreamAccountUseCase = StreamAccountUseCase(streamAccountService: StubStreamAccountService())
    static let mockLoginUseCase = LoginUseCase(loginService: LoginService())
    static let mockTrackMapUseCase = TrackMapUseCase(trackMapService: StubTrackMapService())
}
