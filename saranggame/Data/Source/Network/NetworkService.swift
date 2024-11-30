//
//  NetworkService.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case requestFailed(String)
}

class NetworkService {
    let apiKey = ""
    let baseURL = "https://api.rawg.io/api"
    
    
    func getGenreList() async throws -> [GenreEntity] {
        
        var components = URLComponents(string: "\(baseURL)/genres")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
             throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(GenreListResponse.self, from: data)
            print("result  count: \(result.genreList.count)")
            return result.toEntities()
        } catch {
            throw NetworkError.requestFailed("We encountered an unexpected issue. Please try again.")
        }
    }
    
    func getGameList(_ genreID: String?) async throws -> [GameModel] {
        var components = URLComponents(string: "\(baseURL)/games")!
        var queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        // Only add the "genres" query item if it's not nil
        if let genreID = genreID, !genreID.isEmpty {
            queryItems.append(URLQueryItem(name: "genres", value: genreID))
        }
        
        components.queryItems = queryItems
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(GameListResponse.self, from: data)
            return gameListMapper(input: result.gameList)
        } catch {
            throw NetworkError.requestFailed("We encountered an unexpected issue. Please try again.")
        }
    }
    
    func getGameDetail(_ gameID: String?) async throws -> GameDetailModel {
        var components = URLComponents(string: "\(baseURL)/games/")!
        
        if let gameID = gameID, !gameID.isEmpty {
            components.path.append("\(gameID)")
        }
        
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(GameDetailResponse.self, from: data)
            return GameDetailModel(from: result)
        } catch {
            throw NetworkError.requestFailed("We encountered an unexpected issue. Please try again.")
        }
    }
}

extension NetworkService {
    fileprivate func gameListMapper(
        input gameListResponse: [GameResponse]
    ) -> [GameModel] {
        return gameListResponse.map { result in
            return GameModel(
                id: result.id,
                name: result.name,
                backgroundImage: result.backgroundImage,
                released: result.released,
                rating: result.rating
            )
        }
    }
    
    fileprivate func gameMapper(
        input gameResponse: GameDetailResponse
    ) -> GameDetailModel {
        return GameDetailModel(
            id: gameResponse.id,
            name: gameResponse.name,
            backgroundImage: gameResponse.backgroundImage,
            released: gameResponse.released,
            rating: gameResponse.rating,
            description: gameResponse.description
//            genres: gameResponse.genres.map { $0.toModel()}
        )
    }
}
