//
//  StubInfoService.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import Foundation
import UIKit

struct StubInfoService: InfoServiceInterface {
    func checkPrivacyPolicy() {
        // TODO: 링크 교체
        if let url = URL(string: "https://github.com/Team-PLAT/Plat-iOS") {
            UIApplication.shared.open(url)
        }
    }
    
    func checkTermsOfService() {
        // TODO: 링크 교체
        if let url = URL(string: "https://github.com/Team-PLAT/Plat-iOS") {
            UIApplication.shared.open(url)
        }
    }
    
    func checkSupport() {
        // TODO: 링크 교체
        if let url = URL(string: "https://github.com/Team-PLAT/Plat-iOS") {
            UIApplication.shared.open(url)
        }
    }
}
