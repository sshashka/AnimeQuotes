//
//  AllAnimeAvailablePresenter.swift
//  AnimeQuotes
//
//  Created by Саша Василенко on 09.09.2022.
//

import Foundation

protocol AllAnimeAvailableViewProtocol: AnyObject {
    func getSomeGoodStuff()
}

protocol AllAnimeAvailablePresenterProtocol: AnyObject {
    var data: [String]? {get set}
    func getData()
    func selectedAnimeTitle(title: String)

    init (view: AllAnimeAvailableViewProtocol, network: NetworkManagerProtocol)
}

class AllAnimeAvailablePresenter: AllAnimeAvailablePresenterProtocol {
    
    weak var view: AllAnimeAvailableViewProtocol?
    let network: NetworkManagerProtocol!
    var data: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.getSomeGoodStuff()
            }
        }
    }
    
    required init(view: AllAnimeAvailableViewProtocol, network: NetworkManagerProtocol) {
        self.view = view
        self.network = network
    }
    
    func getData() {
        network.getAllAnimeTitles{ [weak self] (anime) in
            guard let strongSelf = self else { return }
            strongSelf.data = anime
        }
    }
    
    func selectedAnimeTitle(title: String) {
        print("selectedAnimeTitle")
        var info = [String: String]()
        info["titleOfAnime"] = title
        info["title"] = "title"
        NotificationCenter.default.post(name: Notification.Name("selectedAnimeTitle"), object: nil, userInfo: info)
    }
}
