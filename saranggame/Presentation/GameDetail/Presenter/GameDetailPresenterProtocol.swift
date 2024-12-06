//
//  GameDetailPresenterProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit

protocol GameDetailPresenterProtocol: BasePresenter {
    
    func getGameDetail(gameID: String)
    
    func checkIsOnWishlist(gameID: Int)
    
    func addGame()
    
    func removeGame(gameID: Int)
}
