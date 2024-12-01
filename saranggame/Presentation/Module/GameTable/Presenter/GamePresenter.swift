//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class GamePresenter: GamePresenterProtocol {
    private let gameUseCase: GameUseCase
    
    init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getGameList(genreID: String) async throws -> [GameEntity] {
        return try await gameUseCase.getGameList(genreID: genreID)
    }
}
