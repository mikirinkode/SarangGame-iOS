//
//  GameRepositoryProtocol.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

protocol GenreRepositoryProtocol {
    func getGenreList() -> Single<[GenreEntity]>
}
