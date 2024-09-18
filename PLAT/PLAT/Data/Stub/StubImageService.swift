//
//  StubImageService.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import Foundation

struct StubImageService: ImageServiceInterface {
    func uploadImage(imageData: Data) async -> Result<PlatImage, any Error> {
        print(#function)
        return .success(PlatImage(imageUrl: ""))
    }
}
