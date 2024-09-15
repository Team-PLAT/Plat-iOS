//
//  ImageRepository.swift
//  PLAT
//
//  Created by 조우현 on 9/11/24.
//

import Foundation

final class ImageServiceImpl {
    
    private let imageRepository = ImageRepository()
}

final class ImageRepository {
    
    private let client = NetworkClient()
    
    func uploadImage(request: UploadImageRequest) async -> Result<UploadImageResponse, Error> {
        let url = APIs.Plat.Images.upload.url
        let response: Result<BaseResponse<UploadImageResponse>, Error> = await client.post(url: url, body: request)
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
