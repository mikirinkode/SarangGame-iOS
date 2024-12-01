//
//  NetworkService.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case requestFailed(String)
}

class NetworkService {
    let apiKey = ""
    let baseURL = "https://api.rawg.io/api"

    func getGenreList() async throws -> [GenreEntity] {
        let url = "\(baseURL)/genres"
        let parameters: [String: String] = [
            "key": apiKey
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GenreListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        print("Result count: \(result.genreList.count)")
                        continuation.resume(returning: result.toEntities())
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

    func getGameList(_ genreID: String?) async throws -> [GameEntity] {
        let url = "\(baseURL)/games"
        var parameters: [String: String] = [
            "key": apiKey
        ]

        if let genreID = genreID, !genreID.isEmpty {
            parameters["genres"] = genreID
        }

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GameListResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        continuation.resume(returning: result.toEntities())
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
