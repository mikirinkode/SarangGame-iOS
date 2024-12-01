//
//  GameUseCase.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

protocol GameUseCase {
    func getGameList(genreID: String) async throws -> [GameEntity]
    
    func getWishlistGame() async throws -> [GameEntity]
    
    func getGameDetail(gameID: String) async throws -> GameDetailEntity
    
    func checkIsOnWishlist(gameID: Int) async throws -> Bool
    
    func addGame(gameEntity: GameEntity) async throws
    
    func removeGame(gameID: Int) async throws
}
