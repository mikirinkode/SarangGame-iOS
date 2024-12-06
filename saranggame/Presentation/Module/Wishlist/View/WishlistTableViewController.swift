//
//  WishlistTableViewController.swift
//  saranggame
//
//  Created by MacBook on 27/11/24.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
    func showWishlist(_ games: [GameUIModel])
    func showError(message: String)
    func showEmptyView()
}

class WishlistTableViewController: BaseViewController, WishlistViewProtocol {
    
    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescLabel: UILabel!
    
    private var gameList: [GameUIModel] = []
    private lazy var gameProvider: LocalService = { return LocalService() }()
    
    private lazy var presenter: WishlistPresenter = {
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
        
        presenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getWishlistGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.detachView()
    }
    
    func showWishlist(_ games: [GameUIModel]) {
        gameList = games
        wishlistTableView.reloadData()
        errorView.isHidden = true
        emptyView.isHidden = true
    }
    
    func showEmptyView() {
        emptyView.isHidden = false
        errorView.isHidden = true
    }
    
    func showError(message: String) {
        errorDescLabel.text = message
        errorView.isHidden = false
        emptyView.isHidden = true
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
            presenter.getWishlistGame()
        }
    }
}
