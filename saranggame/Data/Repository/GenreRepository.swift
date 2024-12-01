//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenreRepository: GenreRepositoryProtocol {
    
    private let gameDataSource: GenreDataSourceProtocol
    
    init(dataSource: GenreDataSourceProtocol){
        self.gameDataSource = dataSource
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameDataSource.getGenreListFromNetwork()
    }
}

