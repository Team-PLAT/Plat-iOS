//
//  ImageServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import UIKit

protocol ImageServiceInterface {
    func uploadImage(image: UIImage) async -> Result<PlatImage, Error>
}
