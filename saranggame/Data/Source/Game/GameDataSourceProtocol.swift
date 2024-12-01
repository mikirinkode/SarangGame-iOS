//
//  GameDataSourceProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

protocol GameDataSourceProtocol {
    func getGameListFromNetwork(genreID: String) async throws -> [GameEntity]
    
    func getGameDetailFromNetwork(gameID: String) async throws -> GameDetailEntity
    
    func getWishlistGameFromLocal() async throws -> [GameEntity]
    
    func checkIsOnLocalWishlist(gameID: Int) async throws -> Bool
    
    func addGameToLocalWishlist(gameEntity: GameEntity) async throws
    
    func removeGameFromLocalWishlist(gameID: Int) async throws
}
