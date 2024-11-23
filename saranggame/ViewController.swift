//
//  ViewController.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
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
                startDownload(game: game, indexPath: indexPath)
            } else {
                cell.indicatorLoading.startAnimating()
                cell.indicatorLoading.isHidden = true
            }
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    fileprivate func startDownload(game: GameModel, indexPath: IndexPath){
        let imageDownloader = ImageDownloader()
        if (game.state == .new){
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: game.poster)
                    game.state = .downloaded
                    game.image = image
                    self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}

