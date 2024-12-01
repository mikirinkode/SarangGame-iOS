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
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescLabel: UILabel!
    
    private var gameList: [GameUIModel] = []
    private lazy var gameProvider: LocalService = { return LocalService() }()
    
    private lazy var wishlistPresenter: WishlistPresenter = {
        Injection().provideWishlistPresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wishlistTableView.dataSource = self
        wishlistTableView.delegate = self
        
        wishlistTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if gameList.isEmpty {
            Task {
                await getWishlistGameList()
            }
        }
        
    }
    
    func getWishlistGameList() async {
        do {
            errorView.isHidden = true
            let gameEntities = try await wishlistPresenter.getWishlistGame()
            gameList = gameEntities.map { GameUIModel(from: $0) }
            
            wishlistTableView.reloadData()
            emptyView.isHidden = !gameList.isEmpty
        } catch LocalServiceError.fetchError(let message) {
            errorView.isHidden = false
            errorDescLabel.text = message
        } catch {
            errorView.isHidden = false
        }
    }
    
    fileprivate func startDownload(game: GameUIModel, indexPath: IndexPath) {
        Task {
            do {
                let image = try await ImageService.shared.downloadImage(from: game.backgroundImage)
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

extension WishlistTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "gameTableViewCell",
            for: indexPath
        ) as? GameTableViewCell {
            let game = gameList[indexPath.row]
            cell.gameNameLabel.text = game.name
            cell.gameRatingLabel.text = game.rating
            
            cell.gameReleasedDateLabel.text = game.released
            
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
    func onWishlistDataChanged(isShouldRefresh: Bool) {
        if isShouldRefresh {
            Task {
                await self.getWishlistGameList()
            }
        }
    }
}
