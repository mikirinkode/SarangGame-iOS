//
//  GameListResponse.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//



struct GameListResponse: Codable {
    let gameList: [GameResponse]
    
    enum CodingKeys: String, CodingKey {
        case gameList = "results"
    }
}

extension GameListResponse {
    func toEntities() -> [GameEntity] {
        return gameList.map { $0.toEntity() }
    }
}
