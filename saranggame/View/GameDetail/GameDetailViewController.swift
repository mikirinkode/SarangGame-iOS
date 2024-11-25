//
//  GameDetailViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gameNameLabe: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameGenresLabel: UILabel!
    @IBOutlet weak var gameReleasedDateLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    @IBOutlet weak var detailContentView: UIView!
    @IBOutlet weak var fetchIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var imageIndicatorLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    var gameID: String? = nil
    var game: GameDetailModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { await getGameDetail() }
    }
    
    func getGameDetail() async {
        detailContentView.isHidden = true
        fetchIndicatorLoading.isHidden = false
        fetchIndicatorLoading.startAnimating()
        errorView.isHidden = true
        
        defer {
            detailContentView.isHidden = false
            fetchIndicatorLoading.isHidden = true
            fetchIndicatorLoading.stopAnimating()
        }
        
        let network = NetworkService()
        do {
            game = try await network.getGameDetail(gameID)
            if let game = game {
                initView(game: game)
            }
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func initView(game: GameDetailModel){
        detailContentView.isHidden = false
        
        gameNameLabe.text = game.name
        gameRatingLabel.text = "\(game.rating)/5"

        gameGenresLabel.text = game.genres.map { $0.name }.joined(separator: ", ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        gameReleasedDateLabel.text = dateFormatter.string(from: game.released)
        
        let desc = stripHTML(from: game.description)
        gameDescriptionLabel.text = desc
        
        if game.state == .new {
            imageIndicatorLoading.isHidden = false
            imageIndicatorLoading.startAnimating()
            Task {
                do {
                    let imageDownloader = ImageDownloader()
                    
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    
                    backgroundImage.image = image
                    imageIndicatorLoading.isHidden = true
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        } else {
            imageIndicatorLoading.startAnimating()
            imageIndicatorLoading.isHidden = true
        }
        
    }
    
    fileprivate func stripHTML(from html: String) -> String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: html, options: [], range: NSRange(location: 0, length: html.count), withTemplate: "")
    }
    
    func showError(message: String) {
        errorDescriptionLabel.text = message
        errorView.isHidden = false
    }
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        Task { await getGameDetail() }
    }
}

