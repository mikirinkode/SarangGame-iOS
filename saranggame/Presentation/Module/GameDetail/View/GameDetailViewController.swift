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
    @IBOutlet weak var fetchLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    @IBOutlet weak var wishlistButton: UIButton!
    
    var gameID: String?
    var game: GameDetailUIModel?
    
    var isOnWishlist = false
    
    var delegate: GameDetailDelegate?
    var isShouldRefresh: Bool = false
    
    private lazy var gameDetailPresenter: GameDetailPresenter = {
        Injection().provideGameDetailPresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.layer.cornerRadius = 16
        
        updateWishlistIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await getGameDetail()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWishlistDataChanged(isShouldRefresh: isShouldRefresh)
    }
    
    func getGameDetail() async {
        detailContentView.isHidden = true
        wishlistButton.isHidden = true
        
        fetchLoadingIndicator.isHidden = false
        fetchLoadingIndicator.startAnimating()
        errorView.isHidden = true
        
        defer {
            detailContentView.isHidden = false
            fetchLoadingIndicator.isHidden = true
            fetchLoadingIndicator.stopAnimating()
        }
        
        do {
            let gameDetailEntity = try await gameDetailPresenter.getGameDetail(gameID: gameID ?? "0")
            game = GameDetailUIModel(from: gameDetailEntity)
            
            if let game = game {
                initView(game: game)
                Task {
                    await checkIsOnWishlist()
                }
            }
        } catch NetworkError.invalidResponse {
            showError(message: "Invalid response from the server. Please try again.")
        } catch NetworkError.requestFailed(let message) {
            showError(message: message)
        } catch {
            showError(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func checkIsOnWishlist() async {
        do {
            if let id = Int(gameID ?? "0") {
                do {
                    let result = try await gameDetailPresenter.checkIsOnWishlist(gameID: id)
                    
                    self.wishlistButton.isHidden = false
                    self.isOnWishlist = result
                    self.updateWishlistIcon()
                } catch {
                    showError(message: "Unexpected error.")
                }
            }
        }
    }
    
    func initView(game: GameDetailUIModel) {
        detailContentView.isHidden = false
        
        gameNameLabe.text = game.name
        gameRatingLabel.text = game.rating
        gameGenresLabel.text = game.genres
        gameReleasedDateLabel.text = game.released
        gameDescriptionLabel.text = game.description
        
        if game.state == .new {
            imageLoadingIndicator.isHidden = false
            imageLoadingIndicator.startAnimating()
            Task {
                do {
                    
                    let image = try await ImageService.shared.downloadImage(from: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    
                    backgroundImage.image = image
                    imageLoadingIndicator.isHidden = true
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        } else {
            imageLoadingIndicator.startAnimating()
            imageLoadingIndicator.isHidden = true
        }
        
    }
    
    func showError(message: String) {
        errorDescriptionLabel.text = message
        errorView.isHidden = false
    }
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        Task { await getGameDetail() }
    }
    
    @IBAction func wishlistButtonOnClick(_ sender: Any) {
        Task {
            if isOnWishlist {
                let alert = UIAlertController(
                    title: "Remove Game?",
                    message: "Are you sure want to remove this game from your wishlist?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Remove", style: .default) { _ in
                    Task {
                        await self.removeGame()
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            } else {
                await addGame()
            }
        }
    }
    
    func removeGame() async {
        do {
            try await gameDetailPresenter.removeGame(gameID: self.game?.id ?? 0)
            DispatchQueue.main.async {
                self.isOnWishlist = false
                self.updateWishlistIcon()
                self.showToast(message: "Game removed from your wishlist")
                self.isShouldRefresh = true
            }
        } catch LocalServiceError.deleteError(let message) {
            showErrorToast(message: "Failed to remove game: \(message)")
        } catch {
            showErrorToast(message: "An unknown error occurred.")
        }
    }
    
    func addGame() async {
        do {
            guard let gameEntity = game?.toGameEntity() else { throw LocalServiceError.saveError("Invalid Data") }
            try await gameDetailPresenter.addGame(gameEntity: gameEntity)
            DispatchQueue.main.async {
                self.isOnWishlist = true
                self.updateWishlistIcon()
                self.showToast(message: "Game added to your wishlist")
                self.isShouldRefresh = false
            }
        } catch LocalServiceError.saveError(let message) {
            showErrorToast(message: "Failed to add game: \(message)")
        } catch {
            showErrorToast(message: "An unknown error occurred.")
        }
    }
    
    func updateWishlistIcon() {
        wishlistButton.configuration?.image = UIImage(systemName: isOnWishlist ? "heart.fill" : "heart")
    }
    
    func showToast(message: String) {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.accent.withAlphaComponent(0.9)
        toastStyle.messageColor = UIColor.black
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: toastStyle) { _ in }
    }
    
    func showErrorToast(message: String) {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        toastStyle.messageColor = UIColor.black
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: toastStyle) { _ in }
    }
}

protocol GameDetailDelegate {
    func onWishlistDataChanged(isShouldRefresh: Bool)
}
