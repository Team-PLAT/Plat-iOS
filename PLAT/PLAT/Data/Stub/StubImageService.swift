//
//  StubImageService.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import UIKit

struct StubImageService: ImageServiceInterface {
    func uploadImage(image: UIImage) async -> Result<PlatImage, any Error> {
        print(#function)
        return .success(PlatImage(imageUrl: ""))
    }
}
