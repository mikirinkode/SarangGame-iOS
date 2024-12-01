//
//  GameDataSource.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenreDataSource: GenreDataSourceProtocol {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getGenreListFromNetwork() async throws -> [GenreEntity] {
        return try await networkService.getGenreList()
    }
}
