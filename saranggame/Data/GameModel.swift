//
//  GameModel.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class GameModel {
    let title: String
    let poster: URL
    let releaseDate: String
    let rating: Double
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(title: String, poster: URL, releaseDate: String, rating: Double) {
        self.title = title
        self.poster = poster
        self.releaseDate = releaseDate
        self.rating = rating
    }
    
}

let dummyGameList = [
    GameModel(
       title: "Thor: Love and Thunder",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Minions: The Rise of Gru",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Jurassic World Dominion",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Top Gun: Maverick",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "The Gray Man",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/8cXbitsS6dWQ5gfMTZdorpAAzEH.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "The Black Phone",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/p9ZUzCyy9wRTDuuQexkQ78R2BgF.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Lightyear",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/ox4goZd956BxqJH6iLwhWPL9ct4.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Doctor Strange in the Multiverse of Madness",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Indemnity",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/tVbO8EAbegVtVkrl8wNhzoxS84N.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     ), GameModel(
       title: "Borrego",
       poster: URL(string: "https://image.tmdb.org/t/p/w500/kPzQtr5LTheO0mBodIeAXHgthYX.jpg")!,
       releaseDate: "11 Nov 2024",
       rating: 4.5
     )
]
