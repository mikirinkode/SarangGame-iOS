//
//  GameInteractor.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenreUseCaseInteractor: GenreUseCase {
    private let gameRepository: GenreRepositoryProtocol
    
    init(repository: GenreRepositoryProtocol){
        self.gameRepository = repository
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameRepository.getGenreList()
    }
}
