//
//  GameDataSource.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class GameDataSource: GameDataSourceProtocol {
    private let networkService: NetworkService
    private let localService: LocalService
    
    init(networkService: NetworkService, localService: LocalService) {
        self.networkService = networkService
        self.localService = localService
    }
    
    func getGameListFromNetwork(genreID: String) async throws -> [GameEntity] {
        return try await networkService.getGameList(genreID)
    }
    
    func getGameDetailFromNetwork(gameID: String) async throws -> GameDetailEntity {
        return try await networkService.getGameDetail(gameID)
    }
    
    func getWishlistGameFromLocal() async throws -> [GameEntity] {
        return try await localService.getWishlistGame()
    }
    
    func checkIsOnLocalWishlist(gameID: Int) async throws -> Bool {
        return try await localService.checkIsOnWishlist(gameID)
    }
    
    func addGameToLocalWishlist(gameEntity: GameEntity) async throws {
        return try await localService.addGame(gameEntity)
    }
    
    func removeGameFromLocalWishlist(gameID: Int) async throws {
        return try await localService.removeGame(gameID)
    }
}
