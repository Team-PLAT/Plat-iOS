//
//  ReportTrackAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

struct ReportTrackRequset: Encodable {
    let trackId: Int64
}

struct ReportTrackResponse: Decodable {
    let reportId: Int64
}
