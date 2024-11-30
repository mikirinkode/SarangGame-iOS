//
//  GenreListResponse.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

struct GenreListResponse: Codable {
    let genreList: [GenreResponse]
    
    enum CodingKeys: String, CodingKey {
        case genreList = "results"
    }
}

extension GenreListResponse {
    func toEntities() -> [GenreEntity] {
        return genreList.map { $0.toEntity() }
    }
}
