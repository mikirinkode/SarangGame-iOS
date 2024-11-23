//
//  ImageDownloader.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class ImageDownloader: Operation {
    private let game: GameModel
    
    init(game: GameModel){
        self.game = game
    }
    
    override func main(){
        if isCancelled {
            return
        }
        
        guard let imageData = try? Data(contentsOf: self.game.poster) else {return}
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            self.game.image = UIImage(data: imageData)
            self.game.state = .downloaded
        } else {
            self.game.image = nil
            self.game.state = .failed
        }
    }
    
}

class PendingOperations {
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.mikirinkode.imagedownload"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
}
