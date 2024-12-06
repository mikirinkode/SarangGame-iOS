//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 01/12/24.
//
import RxSwift

class GamePresenter: GamePresenterProtocol {
    private weak var view: GameViewProtocol?
    private let gameUseCase: GameUseCase

    let disposeBag = DisposeBag()
    
    init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getGameList(genreID: String) {
        view?.showLoadingIndicator()
        gameUseCase.getGameList(genreID: genreID)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] games in
                guard let self = self else { return }
                
                let uiModels = games.map { GameUIModel(from: $0) }
                if uiModels.isEmpty {
                    self.view?.showError(message: "No games found.")
                } else {
                    self.view?.showGames(uiModels)
                }
            } onError: { error in
                self.view?.showError(message: error.localizedDescription)
            } onCompleted: {
                self.view?.hideLoadingIndicator()
            }.disposed(by: disposeBag)
    }
    
    func attachView(view: GameViewProtocol) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
}
