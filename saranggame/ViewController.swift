//
//  ViewController.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    private let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }

    
    fileprivate func startOperations(game: GameModel, indexPath: IndexPath){
        if game.state == .new {
            startDownload(game: game, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(game: GameModel, indexPath: IndexPath){
        guard pendingOperations.downloadInProgress[indexPath] == nil else {return}
        let downloader = ImageDownloader(game: game)
        
        downloader.completionBlock = {
            if downloader.isCancelled { return  }
            DispatchQueue.main.async {
                self.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    fileprivate func toggleSuspendOperations(isSuspended: Bool){
        pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        toggleSuspendOperations(isSuspended: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyGameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = dummyGameList[indexPath.row]
            cell.gameName.text = game.title
            cell.gameRating.text = "\(game.rating)"
            cell.gameReleaseDate.text = game.releaseDate
            
            cell.gameImage.image = game.image
            
            if game.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startOperations(game: game, indexPath: indexPath)
            } else {
                cell.indicatorLoading.startAnimating()
                cell.indicatorLoading.isHidden = true
            }
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

