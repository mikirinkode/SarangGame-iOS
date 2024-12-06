//
//  GameDetailPresenter.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GameDetailPresenter: GameDetailPresenterProtocol {
    private weak var view: GameDetailViewProtocol?
    
    private let useCase: GameUseCase
    
    private let disposeBag = DisposeBag()
    
    var isOnWishlist: Bool = false
    
    var isShouldRefresh: Bool = false
    
    private var gameModel: GameDetailUIModel?
    
    init(useCase: GameUseCase) {
        self.useCase = useCase
    }
    
    func getGameDetail(gameID: String) {
        view?.showLoadingIndicator()
        useCase.getGameDetail(gameID: gameID)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                let uiModel = GameDetailUIModel(from: result)
                self.gameModel = uiModel
                self.view?.initView(game: uiModel)
                self.view?.hideLoadingIndicator()
                self.checkIsOnWishlist(gameID: Int(gameID) ?? 0)
            } onFailure: { error in
                self.view?.showError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func checkIsOnWishlist(gameID: Int) {
        useCase.checkIsOnWishlist(gameID: gameID)
            .observe(on: MainScheduler.instance)
            .subscribe { isOnWishlist in
                self.isOnWishlist = isOnWishlist
                self.view?.updateWishlistIcon()
            } onFailure: { error in
                self.view?.showError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func addGame() {
        if let gameModel = gameModel {
            let gameEntity = gameModel.toGameEntity()
            useCase.addGame(gameEntity: gameEntity)
                .subscribe(
                    onCompleted: {
                        self.isOnWishlist = true
                        self.isShouldRefresh = false
                        self.view?.updateWishlistIcon()
                        self.view?.showToast(message: "Game added to your wishlist")
                    },
                    onError: { error in
                        self.view?.showError(message: error.localizedDescription)
                    }
                ).disposed(by: disposeBag)
        } else {
            self.view?.showErrorToast(message: "Failed to add Game")
        }
    }
    
    func removeGame(gameID: Int) {
        useCase.removeGame(gameID: gameID)
            .subscribe(
                onCompleted: {
                    self.isOnWishlist = false
                    self.isShouldRefresh = true
                    self.view?.updateWishlistIcon()
                    self.view?.showToast(message: "Game removed from your wishlist")
                },
                onError: { error in
                    self.view?.showError(message: error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
    
    func attachView(view: GameDetailViewProtocol) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
}
