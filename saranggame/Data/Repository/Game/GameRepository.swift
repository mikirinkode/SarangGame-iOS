//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GameRepository: GameRepositoryProtocol {
    private let gameDataSource: GameDataSourceProtocol
    
    init(dataSource: GameDataSourceProtocol) {
        self.gameDataSource = dataSource
    }
    
    func getGameList(genreID: String) -> Single<[GameEntity]> {
        return gameDataSource.getGameListFromNetwork(genreID: genreID)
    }
    
    func getGameDetail(gameID: String) -> Single<GameDetailEntity> {
        return gameDataSource.getGameDetailFromNetwork(gameID: gameID)
    }
    
    func getWishlistGame() -> Observable<[GameEntity]> {
        return gameDataSource.getWishlistGameFromLocal()
    }
    
    func checkIsOnWishlist(gameID: Int) -> Single<Bool> {
        return gameDataSource.checkIsOnLocalWishlist(gameID: gameID)
    }
    
    func addGame(gameEntity: GameEntity) -> Completable {
        return gameDataSource.addGameToLocalWishlist(gameEntity: gameEntity)
    }
    
    func removeGame(gameID: Int) -> Completable {
        return gameDataSource.removeGameFromLocalWishlist(gameID: gameID)
    }
}
