//
//  WishlistProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

class WishlistPresenter: WishlistPresenterProtocol {
    private let useCase: GameUseCase
    
    init(useCase: GameUseCase) {
        self.useCase = useCase
    }
    
    func getWishlistGame() async throws -> [GameEntity] {
        return useCase.getWishlistGame()
    }
}
