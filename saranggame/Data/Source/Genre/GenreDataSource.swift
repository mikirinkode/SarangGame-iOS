//
//  GameDataSource.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

class GenreDataSource: GenreDataSourceProtocol {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getGenreListFromNetwork() -> Single<[GenreEntity]> {
        return networkService.getGenreList()
    }
}
