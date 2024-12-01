//
//  GameDataSourceProtocol.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

protocol GenreDataSourceProtocol {
    func getGenreListFromNetwork() async throws -> [GenreEntity]
}