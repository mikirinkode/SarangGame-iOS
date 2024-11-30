//
//  AppDelegate.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// SarangGameApp project structure
// Data/
// Data/Response/
// - GenreListResponse.swift
// - GenreResponse.swift
// Data/Repository/
// - GameRepository.swift
// - GameRepositoryProtocol.swift
// Data/Source/
// - GameDataSource.swift
// - GameDataSourceProtocol.swift
// - NetworkService.swift
// Data/Utils/
// - ImageService.swift
//
// DI
// Injection.swift
//
// Domain/
// Domain/Entity/
// - GenreEntity.swift
// Domain/UseCase/
// - GameInteractor.swift
// - GamseUseCase.swift
//
// Presentation/
// Presentation/Controller/
// - GenreTableViewController.swift
// Presentation/Presenter/
// - GamePresenter.swift
// - GamePresenterProtocol.swift
// Presentation/UIModel/
// - GenreUIModel.swift
// Presentation/View/
// - GenreTableViewCell.swift
// - GenreTavleViewCell.xib
