//
//  GameRepositoryProtocol.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

protocol GameRepositoryProtocol {
    func getGenreList() async throws -> [GenreEntity]
}
