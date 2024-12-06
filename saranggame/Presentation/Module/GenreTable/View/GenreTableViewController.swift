//
//  ViewController.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit
import RxSwift

protocol GenreViewProtocol: AnyObject {
    func showGenres(_ genres: [GenreUIModel])
    func showError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class GenreTableViewController: BaseViewController, GenreViewProtocol {

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
        
        genrePresenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("GenreTableViewController.viewWillAppear()")
        
        genrePresenter.getGenreList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        genrePresenter.detachView()
    }
    
    func showGenres(_ genres: [GenreUIModel]) {
        print("view, showGenres: \(genres.count)")
        genreList = genres
        genreTableView.reloadData()
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
        errorDescriptionLabel.text = message
        errorView.isHidden = false
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
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        genrePresenter.getGenreList()
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
