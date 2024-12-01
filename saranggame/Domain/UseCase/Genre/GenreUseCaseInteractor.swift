//
//  GameInteractor.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenreUseCaseInteractor: GenreUseCase {
    private let genreRepository: GenreRepositoryProtocol
    
    init(repository: GenreRepositoryProtocol) {
        self.genreRepository = repository
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await genreRepository.getGenreList()
    }
}
