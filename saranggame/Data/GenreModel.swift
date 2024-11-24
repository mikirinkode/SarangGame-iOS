//
//  GenreModel.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//
import UIKit

class GenreModel {
    let id: Int
    let gamesCount: Int
    let name: String
    let imageBackground: URL
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init (id: Int, name: String, imageBackground: URL, gamesCount: Int){
        self.id = id
        self.name = name
        self.imageBackground = imageBackground
        self.gamesCount = gamesCount
    }
}

struct GenreListResponse: Codable {
    let genreList: [GenreResponse]
    
    enum CodingKeys: String, CodingKey {
        case genreList = "results"
    }
}

struct GenreResponse: Codable {
    let id: Int
    let gamesCount: Int
    let name: String
    let imageBackground: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let path = try container.decode(String.self, forKey: .imageBackground)
        
        imageBackground = URL(string: path)!
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        gamesCount = try container.decode(Int.self, forKey: .gamesCount)
    }
}
