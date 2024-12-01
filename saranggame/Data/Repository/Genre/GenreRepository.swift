//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenreRepository: GenreRepositoryProtocol {
    
    private let genreDataSource: GenreDataSourceProtocol
    
    init(dataSource: GenreDataSourceProtocol) {
        self.genreDataSource = dataSource
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await genreDataSource.getGenreListFromNetwork()
    }
}
