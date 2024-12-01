//
//  WishlistTableViewController.swift
//  saranggame
//
//  Created by MacBook on 27/11/24.
//

import UIKit

class WishlistTableViewController: SGBaseViewController {
    
    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var emptyView: UIStackView!
    
    private var gameList: [GameModel] = []
    private lazy var gameProvider: LocalService = { return LocalService() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wishlistTableView.dataSource = self
        wishlistTableView.delegate = self
        
        wishlistTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (gameList.isEmpty) {
            getWishlistGameList()
        }
        
    }
    
    func getWishlistGameList() {
        self.gameProvider.getWishlistGame(completion: { result in
            
            DispatchQueue.main.async{
                self.gameList = result
                self.wishlistTableView.reloadData()
                print("getWishlistGameList completion: \(result)")
                self.emptyView.isHidden = !result.isEmpty
            }
        })
    }
}


extension WishlistTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = gameList[indexPath.row]
            cell.gameNameLabel.text = game.name
            cell.gameRatingLabel.text = "\(game.rating)"
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            cell.gameReleasedDateLabel.text = dateFormatter.string(from: game.released)
            
            cell.gameImage.image = game.image
            
            if game.state == .new {
                cell.imageLoadIndicator.isHidden = false
                cell.imageLoadIndicator.startAnimating()
                startDownload(game: game, indexPath: indexPath)
            } else {
                cell.imageLoadIndicator.startAnimating()
                cell.imageLoadIndicator.isHidden = true
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
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    self.wishlistTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}

extension WishlistTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToGameDetail", sender: "\(gameList[indexPath.row].id)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToGameDetail" {
            if let gameDetailViewController = segue.destination as? GameDetailViewController {
                gameDetailViewController.gameID = sender as? String
                gameDetailViewController.delegate = self
            }
        }
    }
}

extension WishlistTableViewController: GameDetailDelegate {
    func onWishlistDataChanged(isShouldRefresh: Bool){
        if isShouldRefresh {
            self.getWishlistGameList()
        }
    }
}
