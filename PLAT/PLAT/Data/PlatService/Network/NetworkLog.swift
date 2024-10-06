//
//  NetworkLog.swift
//  PLAT
//
//  Created by 김민준 on 9/7/24.
//

import Foundation

#if DEBUG
enum NetworkLog {
    
    private static let isPrint = true
    
    /// 네트워크 성공시 출력합니다.
    static func success<T: Decodable>(
        url: URL,
        statusCode: Int,
        data: T
    ) {
        let message = """
            [✅ SUCCESS]
            - endPoint: \(url.absoluteString)
            - statusCode: \(statusCode)
            =====================================================
            """
        
        if isPrint {
            print(message)
            dump(data)
        }
    }
    
    /// 네트워크 로그를 출력합니다.
    static func failure (
        url: URL,
        statusCode: Int,
        error: Error
    ) {
        let message = """
            [❌ FAILURE]
            - endPoint: \(url.absoluteString)
            - statusCode: \(statusCode)
            =====================================================
            """
        
        if isPrint {
            print(message)
            if let networkError = error as? NetworkError {
                dump(networkError)
            } else {
                dump(error)
            }
        }
    }
}
#endif
