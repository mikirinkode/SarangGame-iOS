//
//  GameUseCase.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

protocol GenreUseCase {
    func getGenreList() -> Single<[GenreEntity]>
}
