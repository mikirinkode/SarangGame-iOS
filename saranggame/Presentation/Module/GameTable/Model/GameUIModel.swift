//
//  GameUIModel.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

class GameUIModel {
    
    let id: Int
    let name: String
    let released: String
    let backgroundImage: URL
    let rating: String
    
    var image: UIImage?
    var state: DownloadState = .new
    var isOnWishlist: Bool = false // TODO: REMOVE
    
    init(from entity: GameEntity) {
        self.id  = entity.id
        self.name = entity.name
        self.backgroundImage = entity.backgroundImage
        self.released = GameUIModel.formatReleasedDate(entity.released)
        self.rating = "\(entity.rating)"
    }
    
    static func formatReleasedDate(_ released: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.string(from: released)
    }
}
