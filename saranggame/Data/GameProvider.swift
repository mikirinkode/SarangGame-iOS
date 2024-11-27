//
//  GameProvider.swift
//  saranggame
//
//  Created by MacBook on 27/11/24.
//

import CoreData
import UIKit

enum GameProviderError: Error {
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
}

class GameProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Game")
        
        container.loadPersistentStores{_, error in guard error == nil else {
            fatalError("Unresolved error \(error!)") // TODO
        }}
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    func getWishlistGame(completion: @escaping(_ gameList: [GameModel]) -> Void){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var gameList: [GameModel] = []
                for result in results {
                    let game = GameModel(
                        id: Int(result.value(forKeyPath: "id") as? Int32 ?? 0),
                        name: result.value(forKeyPath: "name") as? String ?? "",
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? URL ?? URL(string:"")!,
                        released: result.value(forKeyPath: "released") as? Date ?? Date.now,
                        rating: result.value(forKeyPath: "rating") as? Double ?? 0.0
                    )
                    gameList.append(game)
                    print("game id: \(game.id)")
                    print("game name: \(game.name)")
                    print("game backgroundImage: \(game.backgroundImage)")
                    print("game released: \(game.released)")
                    print("game rating: \(game.rating)")
                }
                completion(gameList)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkIsOnWishlist(_ id: Int, completion: @escaping(_ isOnWishlist: Bool) -> Void){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                let result = try taskContext.fetch(fetchRequest).first
                
                completion(result != nil)
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")// TODO
            }
        }
    }
    
    func addGame(
        _ id: Int,
        _ name: String,
        _ backgroundImage: URL,
        _ released: Date,
        _ rating: Double,
        completion: @escaping(Result<Void, GameProviderError>) -> Void
    ) {
        let taskContext = newTaskContext()
        print("adding game")
        print("game id: \(id)")
        print("game name: \(name)")
        print("game backgroundImage: \(backgroundImage)")
        print("game released: \(released)")
        print("game rating: \(rating)")
        
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Game", in: taskContext){
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKey: "id")
                game.setValue(name, forKey: "name")
                game.setValue(backgroundImage, forKey: "backgroundImage")
                game.setValue(released, forKey: "released")
                game.setValue(rating, forKey: "rating")
                game.setValue(true, forKey: "isOnWishlist")
                
                do {
                    try taskContext.save()
                    completion(.success(()))
                } catch let error as NSError {
                    completion(.failure(.saveError("Could not save game: \(error.localizedDescription)")))
                }
            } else {
                completion(.failure(.saveError("Entity not found for Game.")))
            }
        }
    }
    
    func removeGame(_ id: Int, completion: @escaping(Result<Void, GameProviderError>) -> Void){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            
            do {
                  let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                  if batchDeleteResult?.result != nil {
                      completion(.success(()))
                  } else {
                      completion(.failure(.deleteError("No game found to delete.")))
                  }
              } catch let error as NSError {
                  completion(.failure(.deleteError("Could not delete game: \(error.localizedDescription)")))
              }
        }
    }
}
