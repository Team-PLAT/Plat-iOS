//
//  StubMemberService.swift
//  PLAT
//
//  Created by 조우현 on 8/22/24.
//

import UIKit

struct StubMemberService: MemberServiceInterface {
    
    func signIn(socialAccount: SocialAccount) async -> Result<Void, any Error> {
        print(#function)
        return .success(Void())
    }
    
    func signOut() {
        print(#function)
    }
    
    func resign() async -> Result<Void, any Error> {
        print(#function)
        return .success(Void())
    }
    
    func fetchProfile() async -> Result<User, any Error> {
        print(#function)
        return .success(User(id: 0, nickname: "한톨", profileImageUrl: ""))
    }
    
    func updateProfileNickname(to nickname: String) async -> Result<Void, any Error> {
        print(#function)
        return .success(Void())
    }
    
    func updateProfileAvatar(to image: UIImage?) async -> Result<Void, any Error> {
        print(#function)
        return .success(())
    }
    
    func fetchStreamAccount() async -> Result<StreamAccount, any Error> {
        print(#function)
        return .success(.appleMusic)
    }
    
    func updateStreamAccount(to streamAccount: StreamAccount) async -> Result<Void, any Error> {
        print(#function)
        return .success(Void())
    }
}
