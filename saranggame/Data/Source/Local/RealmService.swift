//
//  RealmService.swift
//  saranggame
//
//  Created by Wafa on 06/12/24.
//

import RealmSwift
import Foundation
import RxSwift

enum RealmServiceError: Error {
    case initializationError(String)
    case saveError(String)
    case deleteError(String)
    case fetchError(String)
}

class RealmService {
    private let realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func getWishlistGame() -> Observable<[GameEntity]> {
        return Observable<[GameEntity]>.create { observer in
            if let realm = self.realm {
                let games = realm.objects(GameRealmEntity.self)
                
                // Observe changes to the games collection
                let token = games.observe { changes in
                    switch changes {
                    case .initial(let results), .update(let results, _, _, _):
                        // Map results to GameEntity
                        let gameEntities = results.map {
                            GameEntity(
                                id: $0.id,
                                name: $0.name,
                                released: $0.released,
                                backgroundImage: URL(string: $0.backgroundImage) ?? URL(string: "")!,
                                rating: $0.rating
                            )
                        }
                        print("wishlist realm on changes: \(changes)")
                        observer.onNext(Array(gameEntities))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                // Ensure the token is disposed of properly
                return Disposables.create {
                    token.invalidate()
                }
            } else {
                observer.onError(RealmServiceError.initializationError("Invalid DB"))
            }
            return Disposables.create()
        }
    }
    
    func checkIsOnWishlist(_ id: Int) -> Single<Bool> {
        return Single<Bool>.create { single in
            if let realm = self.realm {
                let gameEntity = realm.object(ofType: GameRealmEntity.self, forPrimaryKey: id)
                
                let isOnWishlist = gameEntity != nil
                single(.success(isOnWishlist))
            } else {
                single(.failure(RealmServiceError.initializationError("Invalid DB")))
            }
            
            return Disposables.create()
        }
    }
    
    func addGame(_ game: GameEntity) -> Completable {
        return Completable.create { completable in
            let gameRealm = GameRealmEntity()
            gameRealm.id = game.id
            gameRealm.name = game.name
            gameRealm.released = game.released
            gameRealm.backgroundImage = game.backgroundImage.absoluteString
            gameRealm.rating = game.rating
            
            do {
                if let realm = self.realm {
                    try realm.write {
                        realm.add(gameRealm, update: .all)
                        completable(.completed)
                    }
                } else {
                    completable(.error(RealmServiceError.initializationError("Invalid DB")))
                }
            } catch {
                completable(
                    .error(
                        RealmServiceError.saveError(
                            "Failed to add game to wishlist: \(error.localizedDescription)"
                        )
                    )
                )
            }
            return Disposables.create()
        }
    }
    
    func removeGame(_ id: Int) -> Completable {
        return Completable.create { completable in
            do {
                if let realm = self.realm {
                    guard let game = realm.object(ofType: GameRealmEntity.self, forPrimaryKey: id) else {
                        throw(RealmServiceError.deleteError("Game not found."))
                    }
                    
                    try realm.write {
                        realm.delete(game)
                        completable(.completed)
                    }
                } else {
                    completable(.error(RealmServiceError.initializationError("Invalid DB")))
                }
            } catch {
                completable(
                    .error(
                        RealmServiceError.saveError(
                            "Failed to remove game from wishlist: \(error.localizedDescription)"
                        )
                    )
                )
            }
            return Disposables.create()
        }
    }
    
    func removeGame(_ id: Int) throws {
        do {
            if let realm = realm {
                guard let game = realm.object(ofType: GameRealmEntity.self, forPrimaryKey: id) else {
                    throw RealmServiceError.deleteError("Game not found.")
                }
                
                try realm.write {
                    realm.delete(game)
                }
            }
        } catch {
            throw RealmServiceError.deleteError("Failed to remove game from wishlist: \(error.localizedDescription)")
        }
    }
}
