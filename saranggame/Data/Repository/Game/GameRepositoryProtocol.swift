//
//  GameRepositoryProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

protocol GameRepositoryProtocol {
    func getGameList(genreID: String) -> Single<[GameEntity]>
    
    func getGameDetail(gameID: String) -> Single<GameDetailEntity>
    
    func getWishlistGame() -> Observable<[GameEntity]> 
    
    func checkIsOnWishlist(gameID: Int) -> Single<Bool>
    
    func addGame(gameEntity: GameEntity) -> Completable 
    
    func removeGame(gameID: Int) -> Completable 
}
