//
//  ImageService.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    
    func downloadImage(from url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        guard let image = UIImage(data: try await imageData) else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
        return image
    }
}
