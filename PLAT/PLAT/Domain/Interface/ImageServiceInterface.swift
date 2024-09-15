//
//  ImageServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import Foundation

protocol ImageServiceInterface {
    func uploadImage(imageData: Data) async -> Result<PlatImage, Error>
}
