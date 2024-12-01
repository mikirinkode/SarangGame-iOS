//
//  GameProvider.swift
//  saranggame
//
//  Created by MacBook on 27/11/24.
//

import CoreData

enum LocalServiceError: Error {
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
}

class LocalService {
    
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
    
    func getWishlistGame() async throws -> [GameEntity] {
        let taskContext = newTaskContext()
        
        return try await taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            let results = try taskContext.fetch(fetchRequest)
            return results.map { result in
                GameEntity(
                    id: Int(result.value(forKeyPath: "id") as? Int32 ?? 0),
                    name: result.value(forKeyPath: "name") as? String ?? "",
                    released: result.value(forKeyPath: "released") as? Date ?? Date.now,
                    backgroundImage: result.value(forKeyPath: "backgroundImage") as? URL ?? URL(string:"")!,
                    rating: result.value(forKeyPath: "rating") as? Double ?? 0.0
                )
            }
        }
    }
    
    func checkIsOnWishlist(_ id: Int) async throws -> Bool {
        let taskContext = newTaskContext()
        
        return try await taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let result = try taskContext.fetch(fetchRequest).first
            return result != nil
        }
    }
    
    func addGame(_ game: GameEntity) async throws {
        let taskContext = newTaskContext()
        
        print("Adding game")
        print("Game id: \(game.id)")
        print("Game name: \(game.name)")
        print("Game backgroundImage: \(game.backgroundImage)")
        print("Game released: \(game.released)")
        print("Game rating: \(game.rating)")
        
        try await taskContext.perform {
            guard let entity = NSEntityDescription.entity(forEntityName: "Game", in: taskContext) else {
                throw LocalServiceError.saveError("Entity not found for Game.")
            }
            
            let managedGame = NSManagedObject(entity: entity, insertInto: taskContext)
            managedGame.setValue(game.id, forKey: "id")
            managedGame.setValue(game.name, forKey: "name")
            managedGame.setValue(game.backgroundImage, forKey: "backgroundImage")
            managedGame.setValue(game.released, forKey: "released")
            managedGame.setValue(game.rating, forKey: "rating")
            managedGame.setValue(true, forKey: "isOnWishlist")
            
            do {
                try taskContext.save()
            } catch {
                throw LocalServiceError.saveError("Could not save game: \(error.localizedDescription)")
            }
        }
    }
    
    func removeGame(_ id: Int) async throws {
        let taskContext = newTaskContext()
        
        try await taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let deletedCount = batchDeleteResult?.result as? Int, deletedCount > 0 {
                    print("Deleted \(deletedCount) game(s) with id: \(id)")
                } else {
                    throw LocalServiceError.deleteError("No game found to delete with id: \(id).")
                }
            } catch {
                throw LocalServiceError.deleteError("Could not delete game: \(error.localizedDescription)")
            }
        }
    }

}
