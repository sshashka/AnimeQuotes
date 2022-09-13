//
//  Builder.swift
//  AnimeQuotes
//
//  Created by Саша Василенко on 08.09.2022.
//

import UIKit

class Builder {
    
    func createRandomModule() -> UIViewController {
        let view = RandomQuotesViewController()
        let networkManager = NetworkManager()
        let dataManager = CoreDataManager()
        let presenter = RandomQuotesModulePresenter(view: view, networkManager: networkManager, dataManager: dataManager)
        view.presenter = presenter
        return view
    }
    
    func createAllAnimeModule() -> UIViewController {
        let view = GetAllAnimeAvailable()
        let networkManager = NetworkManager()
        let presenter = AllAnimeAvailablePresenter(view: view, network: networkManager)
        view.presenter = presenter
        return view
    }
}
