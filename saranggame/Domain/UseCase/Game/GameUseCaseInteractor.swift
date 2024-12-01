//
//  GameUseCaseInteractor.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class GameUseCaseInteractor: GameUseCase {
    private let gameRepository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.gameRepository = repository
    }
    
    func getGameList(genreID: String) async throws -> [GameEntity] {
        return try await gameRepository.getGameList(genreID: genreID)
    }
    
    func getGameDetail(gameID: String) async throws -> GameDetailEntity {
        return try await gameRepository.getGameDetail(gameID: gameID)
    }
    
    func getWishlistGame() async throws -> [GameEntity] {
        return try await gameRepository.getWishlistGame()
    }
}
