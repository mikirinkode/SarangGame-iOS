//
//  GameRepositoryProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

protocol GameRepositoryProtocol {
    func getGameList(genreID: String) -> Observable<[GameEntity]>
    
    func getGameDetail(gameID: String) async throws -> GameDetailEntity
    
    func getWishlistGame() -> Observable<[GameEntity]> 
    
    func checkIsOnWishlist(gameID: Int) async throws -> Bool
    
    func addGame(gameEntity: GameEntity) async throws
    
    func removeGame(gameID: Int) async throws
}
