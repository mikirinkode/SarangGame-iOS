//
//  GenreResponse.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

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

extension GenreResponse {
    func toEntity() -> GenreEntity {
        return GenreEntity(id: id, name: name, gamesCount: gamesCount, imageBackground: imageBackground)
    }
}
