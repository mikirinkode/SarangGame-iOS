//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GenrePresenter: GenrePresenterProtocol {
    private let gameUseCase: GenreUseCase
    
    init(useCase: GenreUseCase){
        self.gameUseCase = useCase
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameUseCase.getGenreList()
    }
}
