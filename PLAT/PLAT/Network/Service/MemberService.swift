//
//  MemberService.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct MemberService {
    static func uploadProfileAvatar(request: UploadProfileAvatarRequest) async -> Result<UploadProfileAvatarResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.uploadProfileAvatar.url
        let response: Result<BaseResponse<UploadProfileAvatarResponse>, Error> = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func fetchProfileStreamType() async -> Result<FetchProfileStreamTypeResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.fetchProfileStreamType.url
        let response: Result<BaseResponse<FetchProfileStreamTypeResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func updateProfileStreamType(request: UpdateProfileStreamTypeRequest) async -> Result<UpdateProfileStreamTypeResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.updateProfileStreamType.url
        let response: Result<BaseResponse<UpdateProfileStreamTypeResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func updateProfileNickname(request: UpdateProfileNicknameRequest) async -> Result<UpdateProfileNicknameResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.updateProfileNickname.url
        let response: Result<BaseResponse<UpdateProfileNicknameResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func updateProfileAvatar(request: UpdateProfileAvatarRequest) async -> Result<UpdateProfileAvatarResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.updateProfileAvatar.url
        let response: Result<BaseResponse<UpdateProfileAvatarResponse>, Error> = await client.patch(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func fetchProfile() async -> Result<FetchProfileResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.fetchProfile.url
        let response: Result<BaseResponse<FetchProfileResponse>, Error> = await client.get(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
    
    static func resign() async -> Result<ResignResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Members.resign.url
        let response: Result<BaseResponse<ResignResponse>, Error> = await client.delete(url: url)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
