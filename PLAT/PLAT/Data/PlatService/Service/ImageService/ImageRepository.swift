//
//  ImageRepository.swift
//  PLAT
//
//  Created by 조우현 on 9/11/24.
//

import Foundation

final class ImageRepository {
    
    private let client = NetworkClient.shared
    
    func uploadImage(request: UploadImageRequest) async -> Result<UploadImageResponse, Error> {
        let url = APIs.Plat.Images.upload.url
        let response: Result<BaseResponse<UploadImageResponse>, Error> = await client.postImage(
            url: url,
            imageData: request.imageData
        )
        do {
            return try .success(response.get().result)
        } catch {
            return .failure(error)
        }
    }
}
