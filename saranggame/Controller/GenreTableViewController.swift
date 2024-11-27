//
//  ViewController.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class GenreTableViewController: SGBaseViewController {

    
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var fetchIndicatorLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    private var genreList: [GenreModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        genreTableView.dataSource = self
        genreTableView.delegate = self
        genreTableView.register(UINib(nibName: "GenreTableViewCell", bundle: nil), forCellReuseIdentifier: "genreTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if genreList.isEmpty {
            Task { await getGenreList() }
        }
    }
    
    func getGenreList() async {
        fetchIndicatorLoading.isHidden = false
        fetchIndicatorLoading.startAnimating()
        errorView.isHidden = true
        
        defer {
            fetchIndicatorLoading.isHidden = true
            fetchIndicatorLoading.stopAnimating()
        }
        
        
        let network = NetworkService()
        do {
            genreList = try await network.getGenreList()
            genreTableView.reloadData()
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
            Task { await getGenreList() }
    }
}

extension GenreTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "genreTableViewCell", for: indexPath) as? GenreTableViewCell {
            let genre = genreList[indexPath.row]
            cell.nameLabel.text = genre.name
            cell.genreCountLabel.text = formatGamesCount(genre.gamesCount)
            
            
            cell.imageBackground.image = genre.image
            
            if genre.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startDownload(genre: genre, indexPath: indexPath)
            } else {
                cell.indicatorLoading.startAnimating()
                cell.indicatorLoading.isHidden = true
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    fileprivate func startDownload(genre: GenreModel, indexPath: IndexPath){
        let imageDownloader = ImageDownloader()
        if (genre.state == .new){
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: genre.imageBackground)
                    genre.state = .downloaded
                    genre.image = image
                    self.genreTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    genre.state = .failed
                    genre.image = nil
                }
            }
        }
    }
    
    fileprivate func formatGamesCount(_ gamesCount: Int) -> String {
        let formattedCount: String
        if gamesCount >= 1_000_000 {
            formattedCount = String(format: "%.1fm", Double(gamesCount) / 1_000_000)
        } else if gamesCount >= 1_000 {
            formattedCount = String(format: "%.0fk", Double(gamesCount) / 1_000)
        } else {
            formattedCount = "\(gamesCount)"
        }
        return "(\(formattedCount) games)"
    }
}

extension GenreTableViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
      performSegue(withIdentifier: "moveToGameList", sender: "\(genreList[indexPath.row].id)")
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToGameList" {
            if let gameTableViewController = segue.destination as? GameTableViewController {
                gameTableViewController.genreID = sender as? String
            }
        }
    }
}