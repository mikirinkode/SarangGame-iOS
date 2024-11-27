//
//  GameDetailViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//

import UIKit
import Toast

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
    
    @IBOutlet weak var wishlistButton: UIButton!
    
    var gameID: String? = nil
    var game: GameDetailModel? = nil
    
    var isOnWishlist = false
    
    private lazy var gameProvider: GameProvider = { return GameProvider() }()
    var delegate: GameDetailDelegate?
    var isShouldRefresh : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.layer.cornerRadius = 16
        
        updateWishlistIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { await getGameDetail() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWishlistDataChanged(isShouldRefresh: isShouldRefresh)
    }
    
    func getGameDetail() async {
        detailContentView.isHidden = true
        wishlistButton.isHidden = true
        
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
                checkIsOnWishlist()
            }
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func checkIsOnWishlist(){
        if let id = Int(gameID ?? "0"){
            gameProvider.checkIsOnWishlist(id)  { result in
                DispatchQueue.main.async {
                    print("checkIsOnWishlist result: \(result)")
                    self.wishlistButton.isHidden = false
                    self.isOnWishlist = result
                    self.updateWishlistIcon()
                }
            }
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
    
    
    @IBAction func wishlistButtonOnClick(_ sender: Any) {
        if (isOnWishlist){
            let alert = UIAlertController(title: "Remove Game?", message: "Are you sure want to remove this game from your wishlist?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Remove", style: .default){ _ in
                self.gameProvider.removeGame(self.game?.id ?? 0) { result in
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success():
                            self.isOnWishlist = false
                            self.updateWishlistIcon()
                            self.showToast(message: "Game removed from your wishlist")
                            self.isShouldRefresh = true
                            
                        case .failure(let error):
                            switch error {
                            case .deleteError(let message):
                                self.showErrorToast(message: "Failed to remove game: \(message)")
                            default:
                                self.showErrorToast(message:"An unknown error occurred.")
                            }
                        }
                    }
                }
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in })
            
            self.present(alert, animated: true)
        } else {
            gameProvider.addGame(game?.id ?? 0, game?.name ?? "", game?.backgroundImage ?? URL(string: "")!, game?.released ?? Date.now, game?.rating ?? 0.0) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.isOnWishlist = true
                        self.updateWishlistIcon()
                        self.showToast(message: "Game added to your wishlist")
                        self.isShouldRefresh = false
                        
                    case .failure(let error):
                        switch error {
                        case .saveError(let message):
                            self.showErrorToast(message: "Failed to add game: \(message)")
                        default:
                            self.showErrorToast(message:"An unknown error occurred.")
                        }
                    }
                }
            }
        }
    }
    
    func updateWishlistIcon(){
        wishlistButton.configuration?.image = UIImage(systemName: isOnWishlist ? "heart.fill" : "heart")
    }
    
    func showToast(message: String){
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.accent.withAlphaComponent(0.9)
        toastStyle.messageColor = UIColor.black
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: toastStyle) { _ in }
    }
    
    func showErrorToast(message: String){
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        toastStyle.messageColor = UIColor.black
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: toastStyle) { _ in }
    }
}

protocol GameDetailDelegate {
    func onWishlistDataChanged(isShouldRefresh: Bool)
}

