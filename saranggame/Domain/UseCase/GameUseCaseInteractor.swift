//
//  GameInteractor.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

class GameUseCaseInteractor: GameUseCase {
    private let gameRepository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol){
        self.gameRepository = repository
    }
    
    func getGenreList() async throws -> [GenreEntity] {
        return try await gameRepository.getGenreList()
    }
}
