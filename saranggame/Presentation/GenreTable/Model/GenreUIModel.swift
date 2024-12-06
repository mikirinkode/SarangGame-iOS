//
//  GenreUIModel.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//

import UIKit

class GenreUIModel {
    let id: Int
    let name: String
    let gamesCount: String
    let imageBackgroundURL: URL
    var image: UIImage?
    var state: DownloadState = .new
    
    init(from entity: GenreEntity) {
        self.id = entity.id
        self.name = entity.name
        self.gamesCount = GenreUIModel.formatGamesCount(entity.gamesCount)
        self.imageBackgroundURL = entity.imageBackground
    }
    
    static func formatGamesCount(_ gamesCount: Int) -> String {
        if gamesCount >= 1_000_000 {
            return String(format: "%.1fm", Double(gamesCount) / 1_000_000)
        } else if gamesCount >= 1_000 {
            return String(format: "%.0fk", Double(gamesCount) / 1_000)
        } else {
            return "\(gamesCount)"
        }
    }
}
