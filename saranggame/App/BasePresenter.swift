//
//  BasePresenter.swift
//  saranggame
//
//  Created by Wafa on 06/12/24.
//

protocol BasePresenter {
    associatedtype View
    
    func attachView(view: View)
    
    func detachView()
}
