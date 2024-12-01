//
//  GameDetailUIModel.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

class GameDetailUIModel {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: URL
    let rating: String
    let description: String
    let genres: String
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(from entity: GameDetailEntity) {
        self.id  = entity.id
        self.name = entity.name
        self.backgroundImage = entity.backgroundImage
        self.released = GameDetailUIModel.formatReleasedDate(entity.released)
        self.rating = "\(entity.rating)/5"
        self.description = GameDetailUIModel.formatDescription(entity.description)
        self.genres = GameDetailUIModel.formatGenres(entity.genres)
    }
    
    static func formatReleasedDate(_ released: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.string(from: released)
    }
    
    static func formatDescription(_ description: String) -> String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: description, options: [], range: NSRange(location: 0, length: description.count), withTemplate: "")
    }
    
    static func formatGenres(_ genres: [GenreEntity]) -> String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
}

extension GameDetailUIModel {
    func toGameEntity() -> GameEntity {
        return GameEntity(id: id, name: name, released: GameDetailUIModel.parseReleasedDate(self.released), backgroundImage: backgroundImage, rating: Double(self.rating.split(separator: "/").first ?? "0") ?? 0.0)
    }
    
    private static func parseReleasedDate(_ released: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.date(from: released) ?? Date()
    }
}
