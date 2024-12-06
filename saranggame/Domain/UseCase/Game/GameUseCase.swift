//
//  GameUseCase.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

protocol GameUseCase {
    func getGameList(genreID: String) -> Single<[GameEntity]>
    
    func getWishlistGame() -> Observable<[GameEntity]> 
    
    func getGameDetail(gameID: String) -> Single<GameDetailEntity>
    
    func checkIsOnWishlist(gameID: Int) -> Single<Bool>
    
    func addGame(gameEntity: GameEntity) -> Completable 
    
    func removeGame(gameID: Int) -> Completable 
}
