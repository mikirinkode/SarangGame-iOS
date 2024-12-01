//
//  GameDetailEntity.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

struct GameDetailEntity {
    let id: Int
    let name: String
    let released: Date
    let backgroundImage: URL
    let rating: Double
    let description: String
    let genres: [GenreEntity]
}
