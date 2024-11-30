//
//  GamePresenterProtocol.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

protocol GamePresenterProtocol {
    func getGenreList() async throws -> [GenreEntity]
}
