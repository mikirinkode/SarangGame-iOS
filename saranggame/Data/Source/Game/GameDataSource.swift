//
//  GameDataSource.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GameDataSource: GameDataSourceProtocol {
    private let networkService: NetworkService
    private let localService: LocalService
    private let realmService: RealmService
    
    init(networkService: NetworkService, localService: LocalService, realmService: RealmService) {
        self.networkService = networkService
        self.localService = localService
        self.realmService = realmService
    }
    
    func getGameListFromNetwork(genreID: String) -> Observable<[GameEntity]> {
        return networkService.getGameList(genreID)
    }
    
    func getGameDetailFromNetwork(gameID: String) async throws -> GameDetailEntity {
        return try await networkService.getGameDetail(gameID)
    }
    
    func getWishlistGameFromLocal() -> Observable<[GameEntity]> {
        return localService.getWishlistGame()
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
