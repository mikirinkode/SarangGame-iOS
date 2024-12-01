//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenrePresenter: GenrePresenterProtocol {
    private let genreUseCase: GenreUseCase
    
    init(useCase: GenreUseCase) {
        self.genreUseCase = useCase
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await genreUseCase.getGenreList()
    }
}
