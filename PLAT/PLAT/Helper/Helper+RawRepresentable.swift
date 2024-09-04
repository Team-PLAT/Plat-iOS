//
//  Helper+RawRepresentable.swift
//  PLAT
//
//  Created by 김민준 on 9/3/24.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: API {
    
    /// Base URL을 붙인 후 반환합니다.
    var url: URL {
        let url = Self.baseUrl.appendingPathComponent(rawValue)
        
        // 마지막 URL이 슬래시로 끝나면 제거 후 반환
        if url.absoluteString.last == "/" {
            var urlString = url.absoluteString
            urlString.removeLast()
            return URL(string: urlString)!
        }
        
        return url
    }
    
    init?(rawValue: String) { nil }
}
