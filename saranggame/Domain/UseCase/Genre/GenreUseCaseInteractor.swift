//
//  GameInteractor.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

class GenreUseCaseInteractor: GenreUseCase {
    private let genreRepository: GenreRepositoryProtocol
    
    init(repository: GenreRepositoryProtocol) {
        self.genreRepository = repository
    }
    
    func getGenreList() -> Single<[GenreEntity]> {
        return genreRepository.getGenreList()
    }
}
