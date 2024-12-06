//
//  NetworkService.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case invalidResponse
    case requestFailed(String)
}

class NetworkService {
    let apiKey = ""
    let baseURL = "https://api.rawg.io/api"

    func getGenreList() -> Single<[GenreEntity]> {
        return Single<[GenreEntity]>.create { single in
            let url = "\(self.baseURL)/genres"
            let parameters: [String: String] = [
                "key": self.apiKey
            ]
            
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GenreListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result.toEntities()))
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            single(.failure(NetworkError.invalidResponse))
                        } else {
                            single(.failure(
                                NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            ))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGameList(_ genreID: String?) -> Single<[GameEntity]> {
        return Single<[GameEntity]>.create { single in
            let url = "\(self.baseURL)/games"
            var parameters: [String: String] = [
                "key": self.apiKey
            ]

            if let genreID = genreID, !genreID.isEmpty {
                parameters["genres"] = genreID
            }
            
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GameListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result.toEntities()))
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            single(.failure(NetworkError.invalidResponse))
                        } else {
                            single(.failure(
                                NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            ))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGameDetail(_ gameID: String) -> Single<GameDetailEntity> {
        return Single<GameDetailEntity>.create { single in
            let url = "\(self.baseURL)/games/\(gameID)"
            let parameters: [String: String] = [
                "key": self.apiKey
            ]
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GameDetailResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result.toEntity()))
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            single(.failure(NetworkError.invalidResponse))
                        } else {
                            single(.failure(
                                NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            ))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
}
