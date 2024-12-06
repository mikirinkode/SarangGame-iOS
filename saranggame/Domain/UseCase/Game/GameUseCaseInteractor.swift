//
//  GameUseCaseInteractor.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GameUseCaseInteractor: GameUseCase {
    private let gameRepository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.gameRepository = repository
    }
    
    func getGameList(genreID: String) -> Single<[GameEntity]> {
        return gameRepository.getGameList(genreID: genreID)
    }
    
    func getGameDetail(gameID: String) -> Single<GameDetailEntity> {
        return gameRepository.getGameDetail(gameID: gameID)
    }
    
    func getWishlistGame() -> Observable<[GameEntity]> {
        return gameRepository.getWishlistGame()
    }
    
    func checkIsOnWishlist(gameID: Int) -> Single<Bool> {
        return gameRepository.checkIsOnWishlist(gameID: gameID)
    }
    
    func addGame(gameEntity: GameEntity) -> Completable {
        return gameRepository.addGame(gameEntity: gameEntity)
    }
    
    func removeGame(gameID: Int) -> Completable {
        return gameRepository.removeGame(gameID: gameID)
    }
}
