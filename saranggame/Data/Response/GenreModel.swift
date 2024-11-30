//
//  GenreModel.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//
import UIKit

class GenreModel {
    let id: Int
    let gamesCount: Int
    let name: String
    let imageBackground: URL
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init (id: Int, name: String, imageBackground: URL, gamesCount: Int){
        self.id = id
        self.name = name
        self.imageBackground = imageBackground
        self.gamesCount = gamesCount
    }
}