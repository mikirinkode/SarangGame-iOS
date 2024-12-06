//
//  GameDataSource.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GameDataSource: GameDataSourceProtocol {
    private let networkService: NetworkService
    private let realmService: RealmService
    
    init(networkService: NetworkService, realmService: RealmService) {
        self.networkService = networkService
        self.realmService = realmService
    }
    
    func getGameListFromNetwork(genreID: String) -> Single<[GameEntity]> {
        return networkService.getGameList(genreID)
    }
    
    func getGameDetailFromNetwork(gameID: String) -> Single<GameDetailEntity> {
        return networkService.getGameDetail(gameID)
    }
    
    func getWishlistGameFromLocal() -> Observable<[GameEntity]> {
        return realmService.getWishlistGame()
    }
    
    func checkIsOnLocalWishlist(gameID: Int) -> Single<Bool> {
        return realmService.checkIsOnWishlist(gameID)
    }
    
    func addGameToLocalWishlist(gameEntity: GameEntity) -> Completable {
        return realmService.addGame(gameEntity)
    }
    
    func removeGameFromLocalWishlist(gameID: Int) -> Completable {
        return realmService.removeGame(gameID)
    }
}
