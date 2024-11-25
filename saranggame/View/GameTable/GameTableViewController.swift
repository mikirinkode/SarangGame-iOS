//
//  GameTableViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//


import UIKit

class GameTableViewController: SGBaseViewController {

    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var fetchIndicatorLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    private var gameList: [GameModel] = []
    var genreID: String? = nil
    
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
            Task { await getGameList() }
        }
    }
    
    func getGameList() async {
        fetchIndicatorLoading.isHidden = false
        fetchIndicatorLoading.startAnimating()
        errorView.isHidden = true
        
        defer {
            fetchIndicatorLoading.isHidden = true
            fetchIndicatorLoading.stopAnimating()
        }
        
        let network = NetworkService()
        do {
            gameList = try await network.getGameList(genreID)
            gameTableView.reloadData()
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func showError(message: String) {
        errorDescriptionLabel.text = message
        errorView.isHidden = false
    }
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        Task { await getGameList() }
    }
}

extension GameTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = gameList[indexPath.row]
            cell.gameName.text = game.name
            cell.gameRating.text = "\(game.rating)"
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            cell.gameReleaseDate.text = dateFormatter.string(from: game.released)
            
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
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
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
