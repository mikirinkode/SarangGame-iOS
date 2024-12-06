//
//  GameDataSourceProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//

import UIKit
import RxSwift

protocol GameDataSourceProtocol {
    func getGameListFromNetwork(genreID: String) -> Single<[GameEntity]>
    
    func getGameDetailFromNetwork(gameID: String) -> Single<GameDetailEntity>
    
    func getWishlistGameFromLocal() -> Observable<[GameEntity]> 
    
    func checkIsOnLocalWishlist(gameID: Int) -> Single<Bool>
    
    func addGameToLocalWishlist(gameEntity: GameEntity) -> Completable
    
    func removeGameFromLocalWishlist(gameID: Int) -> Completable 
}
