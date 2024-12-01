//
//  GameRepositoryProtocol.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

protocol GenreRepositoryProtocol {
    func getGenreList() async throws -> [GenreEntity]
}
