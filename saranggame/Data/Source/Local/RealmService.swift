//
//  RealmService.swift
//  saranggame
//
//  Created by Wafa on 06/12/24.
//

import RealmSwift
import Foundation

enum RealmServiceError: Error {
    case initializationError(String)
    case saveError(String)
    case deleteError(String)
    case fetchError(String)
}

class RealmService {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> RealmService = {
        realmDB in return RealmService(realm: realmDB)
    }
    
    func getWishlistGame() throws -> [GameEntity] {
        do {
            if let realm = realm {
                let games = realm.objects(GameRealmEntity.self)
                return games.map {
                    GameEntity(
                        id: $0.id,
                        name: $0.name,
                        released: $0.released,
                        backgroundImage: URL(string: $0.backgroundImage) ?? URL(string: "")!,
                        rating: $0.rating
                    )
                }
            } else {
                return []
            }
        } catch {
            throw RealmServiceError.fetchError("Failed to fetch wishlist games: \(error.localizedDescription)")
        }
    }
    
    func checkIsOnWishlist(_ id: Int) throws -> Bool {
        do {
            if let realm = realm {
                return realm.object(ofType: GameRealmEntity.self, forPrimaryKey: id) != nil
            } else {
                return false
            }
        } catch {
            throw RealmServiceError.fetchError("Failed to check if game is on wishlist: \(error.localizedDescription)")
        }
    }
    
    func addGame(_ game: GameEntity) throws {
        let gameRealm = GameRealmEntity()
        gameRealm.id = game.id
        gameRealm.name = game.name
        gameRealm.released = game.released
        gameRealm.backgroundImage = game.backgroundImage.absoluteString
        gameRealm.rating = game.rating
        
        do {
            if let realm = realm {
                try realm.write {
                    realm.add(gameRealm, update: .all)
                }
            }
        } catch {
            throw RealmServiceError.saveError("Failed to add game to wishlist: \(error.localizedDescription)")
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
