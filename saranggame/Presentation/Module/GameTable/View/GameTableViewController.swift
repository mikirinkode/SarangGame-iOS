//
//  GameTableViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//


import UIKit

class GameTableViewController: SGBaseViewController {
    
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var fetchLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    private var gameList: [GameUIModel] = []
    var genreID: String? = nil
    
    lazy var gamePresenter: GamePresenter = {
        Injection().provideGamePresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if gameList.isEmpty {
            Task {
                await getGameList()
            }
        }
    }
    
    func getGameList() async {
        fetchLoadingIndicator.isHidden = false
        fetchLoadingIndicator.startAnimating()
        errorView.isHidden = true
        
        defer {
            fetchLoadingIndicator.isHidden = true
            fetchLoadingIndicator.stopAnimating()
        }
        
        do {
            let gameEntities = try await gamePresenter.getGameList(genreID: genreID ?? "0")
            gameList = gameEntities.map { GameUIModel(from: $0) }
            gameTableView.reloadData()
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func startDownload(game: GameUIModel, indexPath: IndexPath){
        if (game.state == .new){
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
    }
    
    func showError(message: String) {
        errorDescriptionLabel.text = message
        errorView.isHidden = false
    }
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        Task {
            await getGameList()
        }
    }
}

extension GameTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell {
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
