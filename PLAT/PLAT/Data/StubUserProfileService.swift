//
//  StubUserProfileService.swift
//  PLAT
//
//  Created by 조우현 on 8/22/24.
//

import Foundation

struct StubUserProfileService: UserProfileServiceInterface {
    func fetchUserInfo() -> User {
        return User(nickname: "IPSUM_LOREM", profileImageUrl: "", streamAccount: .appleMusic)
    }
    
    func updateProfileImage() {
        print(#function)
    }
    
    func updateNickname() {
        print(#function)
    }
    
    func validateNickname(text: String) -> String {
        var newText = text
        if !limitTextLength(text) {
            newText = String(newText.prefix(20))
            return newText
        }
        
        if limitTextSpace(text) {
            return newText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // TODO: 특수문자 처리하기
        
        return newText
    }
}

extension StubUserProfileService {
    /// 특수 기호 체크 메서드
    /// 출처 : https://arc.net/l/quote/ojvfrfrb
    private func limitSpacialCharacter(_ text: String) -> Bool {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: text.utf16.count)
            if regex.firstMatch(in: text, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
    
    /// 글자수 제한 메서드
    private func limitTextLength(_ text: String) -> Bool {
        text.count <= 20
    }
    
    /// 공백 제한 메서드
    private func limitTextSpace(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
}
