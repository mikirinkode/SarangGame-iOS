//
//  GameDetailPresenter.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class GameDetailPresenter: GameDetailPresenterProtocol {
    private let useCase: GameUseCase
    
    init(useCase: GameUseCase) {
        self.useCase = useCase
    }
    
    func getGameDetail(gameID: String) async throws -> GameDetailEntity {
        return try await useCase.getGameDetail(gameID: gameID)
    }
    
    func checkIsOnWishlist(gameID: Int) async throws -> Bool {
        return try await useCase.checkIsOnWishlist(gameID: gameID)
    }
    
    func addGame(gameEntity: GameEntity) async throws {
        return try await useCase.addGame(gameEntity: gameEntity)
    }
    
    func removeGame(gameID: Int) async throws {
        return try await useCase.removeGame(gameID: gameID)
    }
}
