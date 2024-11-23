//
//  ImageDownloader.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class ImageDownloader: Operation {
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
}
