//
//  API.swift
//  PLAT
//
//  Created by 김민준 on 9/3/24.
//

import Foundation

/// API를 추상화하는 프로토콜
protocol API {
    static var baseUrl: URL { get }
}
