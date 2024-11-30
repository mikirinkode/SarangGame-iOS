//
//  GameDetailModel.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//
import UIKit

class GameDetailModel {
    let id: Int
    let name: String
    let released: Date
    let backgroundImage: URL
    let rating: Double
    let description: String
//    let genres: [GenreModel] // TODO
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(id: Int, name: String, backgroundImage: URL, released: Date, rating: Double, description: String) {
        self.id  = id
        self.name = name
        self.backgroundImage = backgroundImage
        self.released = released
        self.rating = rating
        self.description = description
//        self.genres = genres
    }
    
}


struct GameDetailResponse: Codable {
    
    let id: Int
    let name: String
    let released: Date
    let backgroundImage: URL
    let rating: Double
    let description: String
    let genres: [GenreResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case description
        case genres
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
        
        description = try container.decode(String.self, forKey: .description)
        
        genres = try container.decode([GenreResponse].self, forKey: .genres)
    }
}

extension GameDetailModel {
    convenience init(from response: GameDetailResponse) {
        self.init(
            id: response.id,
            name: response.name,
            backgroundImage: response.backgroundImage,
            released: response.released,
            rating: response.rating,
            description: response.description
//            genres: response.genres.map { $0.toModel() }
        )
    }
}

