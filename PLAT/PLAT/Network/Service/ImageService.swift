//
//  ImageService.swift
//  PLAT
//
//  Created by 조우현 on 9/11/24.
//

import Foundation

struct ImageService {
    static func uploadImage(request: UploadImageRequest) async -> Result<UploadImageResponse, Error> {
        let client = NetworkClient()
        let url = APIs.Plat.Images.upload.url
        let response: Result<BaseResponse<UploadImageResponse>, Error> = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
