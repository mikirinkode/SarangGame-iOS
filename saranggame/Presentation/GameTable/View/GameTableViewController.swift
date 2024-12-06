//
//  GameTableViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//

import UIKit

protocol GameViewProtocol: AnyObject {
    func showGames(_ games: [GameUIModel])
    func showError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class GameTableViewController: BaseViewController, GameViewProtocol {
        
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var fetchLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    private var gameList: [GameUIModel] = []
    var genreID: String?
    
    lazy var presenter: GamePresenter = {
        Injection().provideGamePresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
        
        presenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getGameList(genreID: genreID ?? "0")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.detachView()
    }
    
    func showGames(_ games: [GameUIModel]) {
        hideLoadingIndicator()
        gameList = games
        gameTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        fetchLoadingIndicator.isHidden = false
        fetchLoadingIndicator.startAnimating()
        errorView.isHidden = true
    }
    
    func hideLoadingIndicator() {
        fetchLoadingIndicator.isHidden = true
        fetchLoadingIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        hideLoadingIndicator()
        errorDescriptionLabel.text = message
        errorView.isHidden = false
    }
    
    fileprivate func startDownload(game: GameUIModel, indexPath: IndexPath) {
        Task {
            do {
                let image = try await ImageService.shared.downloadImage(from: game.backgroundImage)
                game.state = .downloaded
                game.image = image
                self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                game.state = .failed
                game.image = nil
            }
        }
    }
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        presenter.getGameList(genreID: genreID ?? "0")
    }
}

extension GameTableViewController: UITableViewDataSource {
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

extension GameTableViewController: UITableViewDelegate {
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
            }
        }
    }
}
