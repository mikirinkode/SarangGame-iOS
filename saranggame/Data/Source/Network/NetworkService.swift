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

    func getGenreList() -> Observable<[GenreEntity]> {
        return Observable<[GenreEntity]>.create { observer in
            let url = "\(self.baseURL)/genres"
            let parameters: [String: String] = [
                "key": self.apiKey
            ]
            
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GenreListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        observer.onNext(result.toEntities())
                        observer.onCompleted()
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            observer.onError(NetworkError.invalidResponse)
                        } else {
                            observer.onError(
                                NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            )
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGameList(_ genreID: String?) -> Observable<[GameEntity]> {
        return Observable<[GameEntity]>.create { observer in
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
                        observer.onNext(result.toEntities())
                        observer.onCompleted()
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            observer.onError(NetworkError.invalidResponse)
                        } else {
                            observer.onError(
                                NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            )
                        }
                    }
                }
            return Disposables.create()
        }
    }

    func getGameDetail(_ gameID: String) async throws -> GameDetailEntity {
        let url = "\(baseURL)/games/\(gameID)"
        let parameters: [String: String] = [
            "key": apiKey
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GameDetailResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        continuation.resume(returning: result.toEntity())
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            continuation.resume(throwing: NetworkError.invalidResponse)
                        } else {
                            continuation.resume(
                                throwing: NetworkError.requestFailed(
                                    "We encountered an unexpected issue. Please try again."
                                )
                            )
                        }
                    }
                }
        }
    }

}
