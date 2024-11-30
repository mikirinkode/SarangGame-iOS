//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GamePresenter: GamePresenterProtocol {
    private let gameUseCase: GameUseCase
    
    init(useCase: GameUseCase){
        self.gameUseCase = useCase
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameUseCase.getGenreList()
    }
}
