//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GameRepository: GameRepositoryProtocol {
    
    private let gameDataSource: GameDataSourceProtocol
    
    init(dataSource: GameDataSourceProtocol){
        self.gameDataSource = dataSource
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameDataSource.getGenreListFromNetwork()
    }
}

