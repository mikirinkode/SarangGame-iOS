//
//  GameDetailViewController.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//

import UIKit
import Toast

protocol GameDetailViewProtocol: AnyObject {
    func initView(game: GameDetailUIModel)
    func showError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showToast(message: String)
    func showErrorToast(message: String)
    func updateWishlistIcon()
}

class GameDetailViewController: UIViewController, GameDetailViewProtocol {
    
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
    
    var delegate: GameDetailDelegate?
    var isShouldRefresh: Bool = false
    
    private lazy var presenter: GameDetailPresenter = {
        Injection().provideGameDetailPresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.layer.cornerRadius = 16
        
        presenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getGameDetail(gameID: gameID ?? "0")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWishlistDataChanged(isShouldRefresh: isShouldRefresh)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.detachView()
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
        hideLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        detailContentView.isHidden = true
        errorView.isHidden = true
        fetchLoadingIndicator.isHidden = false
        fetchLoadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        fetchLoadingIndicator.isHidden = true
        fetchLoadingIndicator.stopAnimating()
    }
    
    func updateWishlistIcon() {
        wishlistButton.configuration?.image = UIImage(systemName: presenter.isOnWishlist ? "heart.fill" : "heart")
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
    
    @IBAction func tryAgainButtonOnClick(_ sender: Any) {
        presenter.getGameDetail(gameID: gameID ?? "0")
    }
    
    @IBAction func wishlistButtonOnClick(_ sender: Any) {
        Task {
            if presenter.isOnWishlist {
                let alert = UIAlertController(
                    title: "Remove Game?",
                    message: "Are you sure want to remove this game from your wishlist?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Remove", style: .default) { _ in
                    self.presenter.removeGame(gameID: Int(self.gameID ??  "0") ?? 0)
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            } else {
                presenter.addGame()
            }
        }
    }
}

protocol GameDetailDelegate: AnyObject {
    func onWishlistDataChanged(isShouldRefresh: Bool)
}
