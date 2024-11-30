//
//  GameModel.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class GameModel {
    let id: Int
    let name: String
    let released: Date
    let backgroundImage: URL
    let rating: Double
    
    var image: UIImage?
    var state: DownloadState = .new
    var isOnWishlist: Bool = false
    
    init(id: Int, name: String, backgroundImage: URL, released: Date, rating: Double) {
        self.id  = id
        self.name = name
        self.backgroundImage = backgroundImage
        self.released = released
        self.rating = rating
    }
    
}

struct GameListResponse: Codable {
    let gameList: [GameResponse]
    
    enum CodingKeys: String, CodingKey {
        case gameList = "results"
    }
}

struct GameResponse: Codable {
    
    let id: Int
    let name: String
    let released: Date
    let backgroundImage: URL
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let path = try container.decode(String.self, forKey: .backgroundImage)
        backgroundImage = URL(string: path)!
        
        let dateString = try container.decode(String.self, forKey: .released)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        released = dateFormatter.date(from: dateString)!
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Double.self, forKey: .rating)
    }
}
