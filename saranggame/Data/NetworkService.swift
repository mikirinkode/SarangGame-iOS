//
//  NetworkService.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import Foundation

class NetworkService {
    let apiKey = ""
    
    func getGenreList() async throws -> [GenreModel] {
        var components = URLComponents(string: "https://api.rawg.io/api/genres")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Failed fetching genre list data")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GenreListResponse.self, from: data)
        return genreListMapper(input: result.genreList)
    }
    
    func getGameList(_ genreID: String?) async throws -> [GameModel] {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
         var queryItems = [
             URLQueryItem(name: "key", value: apiKey)
         ]

         // Only add the "genres" query item if it's not nil
        if let genreID = genreID, !genreID.isEmpty {
            queryItems.append(URLQueryItem(name: "genres", value: genreID))
            print("getGameList. genreId: \(genreID)")
         }

         components.queryItems = queryItems
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Failed fetching game list data")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameListResponse.self, from: data)
        return gameListMapper(input: result.gameList)
    }
}

extension NetworkService {
    
    fileprivate func genreListMapper(
        input genreListResponse: [GenreResponse]
    ) -> [GenreModel] {
        return genreListResponse.map { result in
            return GenreModel(id: result.id, name: result.name, imageBackground: result.imageBackground, gamesCount: result.gamesCount)
        }
    }
    
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
}
