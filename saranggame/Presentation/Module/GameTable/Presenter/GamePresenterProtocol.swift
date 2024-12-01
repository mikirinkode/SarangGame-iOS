//
//  GamePresenterProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

protocol GamePresenterProtocol {
    func getGameList(genreID: String) async throws -> [GameEntity]
}
