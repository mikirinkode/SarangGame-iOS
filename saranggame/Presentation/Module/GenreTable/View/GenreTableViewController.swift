//
//  ViewController.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class GenreTableViewController: SGBaseViewController {

    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var fetchLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    private var genreList: [GenreUIModel] = []

    private lazy var genrePresenter: GenrePresenter = {
        Injection().provideGenrePresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GenreTableViewController.viewDidLoad()")
        // Do any additional setup after loading the view.
        
        genreTableView.dataSource = self
        genreTableView.delegate = self
        genreTableView.register(
            UINib(nibName: "GenreTableViewCell", bundle: nil),
            forCellReuseIdentifier: "genreTableViewCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("GenreTableViewController.viewWillAppear()")
        
        if genreList.isEmpty {
            Task {
                await getGenreList()
            }
        }
    }
    
    func getGenreList() async {
        print("controller.getGenreList()")
        fetchLoadingIndicator.isHidden = false
        fetchLoadingIndicator.startAnimating()
        errorView.isHidden = true
        
        defer {
            fetchLoadingIndicator.isHidden = true
            fetchLoadingIndicator.stopAnimating()
        }
        
        do {
            let genreEntities = try await genrePresenter.getGenreList()
            genreList = genreEntities.map { GenreUIModel(from: $0) }
            
            genreTableView.reloadData()
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func startDownload(genre: GenreUIModel, indexPath: IndexPath) {
        Task {
            do {
                let image = try await ImageService.shared.downloadImage(from: genre.imageBackgroundURL)
                genre.image = image
                genre.state = .downloaded
                genreTableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                genre.state = .failed
                genre.image = nil
            }
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
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "genreTableViewCell",
            for: indexPath
        ) as? GenreTableViewCell {
            let genre = genreList[indexPath.row]
            cell.nameLabel.text = genre.name
            cell.genreCountLabel.text = genre.gamesCount
            
            cell.imageBackground.image = genre.image
            
            if genre.state == .new {
                cell.imageLoadIndicator.isHidden = false
                cell.imageLoadIndicator.startAnimating()
                startDownload(genre: genre, indexPath: indexPath)
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
