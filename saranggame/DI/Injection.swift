//
//  Injection.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

import UIKit
import RealmSwift

final class Injection: NSObject {
    
    private func provideNetworkService() -> NetworkService {
        return NetworkService()
    }
    
    private func provideGenreDataSource() -> GenreDataSourceProtocol {
        let networkService = provideNetworkService()
        
        return GenreDataSource(networkService: networkService)
    }
    
    private func provideRealmService() -> RealmService {
        let realm = try? Realm()
        return RealmService(realm: realm)
     }
     
     private func provideGameDataSource() -> GameDataSourceProtocol {
         let networkService = provideNetworkService()
         let realmService = provideRealmService()
         
         return GameDataSource(networkService: networkService, realmService: realmService)
     }
    
    private func provideGenreRepository() -> GenreRepositoryProtocol {
        let genreDataSource = provideGenreDataSource()
        
        return GenreRepository(dataSource: genreDataSource)
    }
    
    private func provideGameRepository() -> GameRepositoryProtocol {
        let gameDataSource = provideGameDataSource()
        
        return GameRepository(dataSource: gameDataSource)
    }
    
    private func provideGenreUseCase() -> GenreUseCase {
        let genreRepository = provideGenreRepository()
        
        return GenreUseCaseInteractor(repository: genreRepository)
    }
    
    private func provideGameUseCase() -> GameUseCase {
        let gameRepository = provideGameRepository()
        
        return GameUseCaseInteractor(repository: gameRepository)
    }
    
    func provideGenrePresenter() -> GenrePresenter {
        let useCase = provideGenreUseCase()
        
        return GenrePresenter(useCase: useCase)
    }
    
    func provideGamePresenter() -> GamePresenter {
        let useCase = provideGameUseCase()
        
        return GamePresenter(gameUseCase: useCase)
    }
    
    func provideGameDetailPresenter() -> GameDetailPresenter {
        let useCase = provideGameUseCase()
        
        return GameDetailPresenter(useCase: useCase)
    }
    
    func provideWishlistPresenter() -> WishlistPresenter {
        let useCase = provideGameUseCase()
        
        return WishlistPresenter(useCase: useCase)
    }
}
