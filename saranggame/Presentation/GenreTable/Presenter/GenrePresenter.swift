//
//  GamePresenter.swift
//  saranggame
//
//  Created by MacBook on 30/11/24.
//
import RxSwift

class GenrePresenter: GenrePresenterProtocol {
    private weak var view: GenreViewProtocol?
    private let genreUseCase: GenreUseCase
    
    let disposeBag = DisposeBag()
    
    init(useCase: GenreUseCase) {
        self.genreUseCase = useCase
    }
    
    func getGenreList() {
        print("presenter, getGenreList")
        self.view?.showLoadingIndicator()
        genreUseCase.getGenreList()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] genres in
                guard let self = self else { return }
                
                let uiModels = genres.map { GenreUIModel(from: $0) }
                if uiModels.isEmpty {
                    self.view?.showError(message: "No genres found.")
                } else {
                    self.view?.showGenres(uiModels)
                }
            } onFailure: { error in
                self.view?.showError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func attachView(view: GenreViewProtocol) {
        print("attach view")
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
}
