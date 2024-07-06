//
//  InfoUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

@Observable
final class InfoUseCase {
    
    private(set) var infoService: InfoServiceInterface
    private(set) var state: State
    
    init(infoService: InfoServiceInterface) {
        self.infoService = infoService
        self.state = State()
    }
}

// MARK: - State

extension InfoUseCase {
    
    struct State {
        
    }
}

// MARK: - UseCase Method

extension InfoUseCase {
    
    /// 개인정보보호정책 보기
    func checkPrivacyPolicy() {
        infoService.checkPrivacyPolicy()
    }
    
    /// 서비스 이용약관 보기
    func checkTermsOfService() {
        infoService.checkTermsOfService()
    }
    
    /// 지원 보기
    func checkSupport() {
        infoService.checkSupport()
    }
}
