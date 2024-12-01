//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class GameRepository: GameRepositoryProtocol {
    private let gameDataSource: GameDataSourceProtocol
    
    init(dataSource: GameDataSourceProtocol) {
        self.gameDataSource = dataSource
    }
    
    func getGameList(genreID: String) async throws -> [GameEntity] {
        return try await gameDataSource.getGameListFromNetwork(genreID: genreID)
    }
    
    func getGameDetail(gameID: String) async throws -> GameDetailEntity {
        return try await gameDataSource.getGameDetailFromNetwork(gameID: gameID)
    }
    
    func getWishlistGame() async throws -> [GameEntity] {
        return try await gameDataSource.getWishlistGameFromLocal()
    }
    
    func checkIsOnWishlist(gameID: Int) async throws -> Bool {
        return try await gameDataSource.checkIsOnLocalWishlist(gameID: gameID)
    }
    
    func addGame(gameEntity: GameEntity) async throws {
        return try await gameDataSource.addGameToLocalWishlist(gameEntity: gameEntity)
    }
    
    func removeGame(gameID: Int) async throws {
        return try await gameDataSource.removeGameFromLocalWishlist(gameID: gameID)
    }
}
