//
//  StreamAccountUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

@Observable
final class StreamAccountUseCase {
    
    private(set) var streamAccountService: StreamAccountServiceInterface
    private(set) var state: State
    
    init(streamAccountService: StreamAccountServiceInterface) {
        self.streamAccountService = streamAccountService
        self.state = State()
    }
}

// MARK: - State

extension StreamAccountUseCase {
    
    struct State {
        
    }
}

// MARK: - UseCase Method

extension StreamAccountUseCase {
    
    /// 스트리밍 계정 연결하기
    func connect(streamAccount: StreamAccount) {
        streamAccountService.connect(streamAccount: streamAccount)
    }
}
