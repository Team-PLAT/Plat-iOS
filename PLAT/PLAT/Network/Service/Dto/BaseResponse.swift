//
//  BaseResponse.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

struct BaseResponse<ResultType: Decodable>: Decodable {
    let timestamp: String
    let code: String
    let message: String
    let result: ResultType
}
