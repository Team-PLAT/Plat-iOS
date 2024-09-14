//
//  MemberServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 9/14/24.
//

import Foundation

protocol MemberServiceInterface {
    func signIn(socialAccount: SocialAccount) async -> Result<Void, Error>
    func resign() async -> Result<Void, Error>
    
    func fetchProfile() async -> Result<User, Error>
    func updateProfileNickname(to nickname: String) async -> Result<Void, Error>
    func updateProfileAvatar(imageUrl: String) async -> Result<Void, Error>
    
    func fetchStreamAccount() async -> Result<StreamAccount, Error>
    func updateStreamAccount(to streamAccount: StreamAccount) async -> Result<Void, Error>
}
