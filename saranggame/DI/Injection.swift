//
//  Injection.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

import UIKit

final class Injection: NSObject {
    
    private func provideNetworkService() -> NetworkService {
        return NetworkService()
    }
    
    private func provideDataSource() -> GameDataSourceProtocol {
        let networkService = provideNetworkService()
        
        return GameDataSource(networkService: networkService)
    }
    
    private func provideRepository() -> GameRepositoryProtocol {
        let gameDataSource = provideDataSource()
        
        return GameRepository(dataSource: gameDataSource)
    }
    
    func provideUseCase() -> GameUseCase {
        let gameRepository = provideRepository()
        
        return GameUseCaseInteractor(repository: gameRepository)
    }
    
    func provideGamePresenter() -> GamePresenter {
        let useCase = provideUseCase()
        
        return GamePresenter(useCase: useCase)
    }
}
