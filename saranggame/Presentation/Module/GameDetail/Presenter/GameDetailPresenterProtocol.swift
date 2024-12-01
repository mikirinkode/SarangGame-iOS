//
//  GameDetailPresenterProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

protocol GameDetailPresenterProtocol {
    func getGameDetail(gameID: String) async throws -> GameDetailEntity
    
    func checkIsOnWishlist(gameID: Int) async throws -> Bool
    
    func addGame(gameEntity: GameEntity) async throws
    
    func removeGame(gameID: Int) async throws
}
