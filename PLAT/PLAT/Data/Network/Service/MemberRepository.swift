//
//  MemberService.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

final class MemberRepository {
    
    private let client = NetworkClient()
    
    func signIn(request: SignInRequest) async -> Result<SignInResponse, Error> {
        let url = APIs.Plat.Members.signIn.url
        let response: Result<BaseResponse<SignInResponse>, Error> = await client.signIn(
            url: url,
            body: request
        )
        
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func resign() async -> Result<ResignResponse, Error> {
        let url = APIs.Plat.Members.resign.url
        let response: Result<BaseResponse<ResignResponse>, Error> = await client.delete(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchProfile() async -> Result<FetchProfileResponse, Error> {
        let url = APIs.Plat.Members.fetchProfile.url
        let response: Result<BaseResponse<FetchProfileResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func updateProfileNickname(request: UpdateProfileNicknameRequest) async -> Result<UpdateProfileNicknameResponse, Error> {
        let url = APIs.Plat.Members.updateProfileNickname.url
        let response: Result<BaseResponse<UpdateProfileNicknameResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func updateProfileAvatar(request: UpdateProfileAvatarRequest) async -> Result<UpdateProfileAvatarResponse, Error> {
        let url = APIs.Plat.Members.updateProfileAvatar.url
        let response: Result<BaseResponse<UpdateProfileAvatarResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchStreamAccount() async -> Result<FetchProfileStreamTypeResponse, Error> {
        let url = APIs.Plat.Members.fetchProfileStreamType.url
        let response: Result<BaseResponse<FetchProfileStreamTypeResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    func updateStreamAccount(request: UpdateProfileStreamTypeRequest) async -> Result<UpdateProfileStreamTypeResponse, Error> {
        let url = APIs.Plat.Members.updateProfileStreamType.url
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = [
            URLQueryItem(name: "streamType", value: request.streamType.rawValue)
        ]
        if let urlComponent = urlComponent,
           let url = urlComponent.url {
            let response: Result<BaseResponse<UpdateProfileStreamTypeResponse>, Error> = await client.patch(url: url, body: request)
            do {
                return try .success(response.get().result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(NetworkError.urlComponentsError)
        }
    }
}
