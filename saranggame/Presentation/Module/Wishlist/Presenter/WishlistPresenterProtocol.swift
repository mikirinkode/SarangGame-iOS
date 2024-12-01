//
//  WishlistPresenterProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

protocol WishlistPresenterProtocol {
    func getWishlistGame() async throws -> [GameEntity]
}
