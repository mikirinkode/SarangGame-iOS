//
//  GameRepository.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

class GenreRepository: GenreRepositoryProtocol {
    
    private let genreDataSource: GenreDataSourceProtocol
    
    init(dataSource: GenreDataSourceProtocol) {
        self.genreDataSource = dataSource
    }
    
    func getGenreList() -> Observable<[GenreEntity]> {
        return genreDataSource.getGenreListFromNetwork()
    }
}
