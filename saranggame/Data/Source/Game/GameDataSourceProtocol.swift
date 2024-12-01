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
    
//    func checkIsOnLocalWishlist() async throws -> Bool
//    
//    func addGame(id: Int, name: String, backgroundImage: URL, released: Date, rating: Double) async throws -> Result<Void, LocalServiceError>
//    
//    func removeGame(id: Int) async throws -> Result<Void, LocalServiceError>
}
