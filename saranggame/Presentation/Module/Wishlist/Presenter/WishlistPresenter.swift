//
//  WishlistProtocol.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class WishlistPresenter: WishlistPresenterProtocol {
    private weak var view: WishlistViewProtocol?
    private let useCase: GameUseCase
    
    let disposeBag = DisposeBag()
    
    init(useCase: GameUseCase) {
        self.useCase = useCase
    }
    
    func getWishlistGame() {
        useCase.getWishlistGame()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] games in
                guard let self = self else { return }
                
                let uiModels = games.map { GameUIModel(from: $0) }
                if uiModels.isEmpty {
                    self.view?.showEmptyView()
                } else {
                    self.view?.showWishlist(uiModels)
                }
            } onError: { error in
                self.view?.showError(message: error.localizedDescription)
            } onCompleted: {
            }.disposed(by: disposeBag)
    }
    
    func attachView(view: WishlistViewProtocol) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
}
