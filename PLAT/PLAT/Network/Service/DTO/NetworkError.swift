//
//  NetworkError.swift
//  PLAT
//
//  Created by 조세연 on 8/20/24.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case serverError(statusCode: Int)
    case urlError(URLError)
    case error(Error)
    case urlComponentsError

    var localizedDescription: String {
        switch self {
        case .decodingError:
            return "🥵 디코딩 오류"
        case .serverError(let statusCode):
            return "🥵 서버 오류 \(statusCode)"
        case .urlError(let urlError):
            return urlError.localizedDescription
        case .error(let error):
            return error.localizedDescription
        case .urlComponentsError:
            return "🥵 URLComponents 오류"
        }
    }
}
