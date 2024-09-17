//
//  ImageServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import Foundation

final class ImageServiceImpl: ImageServiceInterface {
    
    private let imageRepository = ImageRepository()
    
    /// 이미지를 업로드 후, 이미지가 저장된 URL을 반환합니다.
    func uploadImage(imageData: Data) async -> Result<PlatImage, any Error> {
        let request = UploadImageRequest(imageData: imageData)
        let result = await imageRepository.uploadImage(request: request)
        switch result {
        case .success(let uploadImageResponse):
            return .success(PlatImage(imageUrl: uploadImageResponse.avatar))
        case .failure(let error):
            return .failure(error)
        }
    }
}
