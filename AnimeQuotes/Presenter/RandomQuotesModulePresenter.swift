import Foundation

protocol RandomQuotesViewPresenterProtocol: AnyObject {
    func showSomeGoodStuff()
}

protocol RandomQuotesModulePresenterProtocol: AnyObject {
    var data: [Model]? {get set}
    func getData()
    func saveData(at index: Int)
    init(view: RandomQuotesViewPresenterProtocol, networkManager: NetworkManagerProtocol, dataManager: CoreDataManager)
}

class RandomQuotesModulePresenter: RandomQuotesModulePresenterProtocol {
    var data: [Model]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.showSomeGoodStuff()
            }
        }
    }
    
    weak var view: RandomQuotesViewPresenterProtocol?
    let networkManager: NetworkManagerProtocol!
    let dataManager: CoreDataManager!
    
    required init(view: RandomQuotesViewPresenterProtocol, networkManager: NetworkManagerProtocol, dataManager: CoreDataManager) {
        self.view = view
        self.networkManager = networkManager
        self.dataManager = dataManager
        NotificationCenter.default.addObserver(self, selector: #selector(getDataForSpecificAnime(_:)), name: NSNotification.Name("selectedAnimeTitle"), object: nil)
        getData()
    }
    
    deinit {
        print("deinited")
    }
    
    func getData()  {
        networkManager.getTenRandomQuotes { [weak self] (quotes) in
            guard let strongSelf = self else { return }
            strongSelf.data = quotes
        }
    }
    
    func saveData(at index: Int) {
        guard let data = data else { return }
        let anime = data[index]
        CoreDataManager().saveContext(for: anime)
        CoreDataManager().getData()
    }
    
    @objc func getDataForSpecificAnime(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let title = dict["titleOfAnime"] as? String {
                networkManager.searchAnimeQuotesByTitle(title: title) { [weak self] (quotes) in
                    guard let strongSelf = self else { return }
                    strongSelf.data = quotes
                }
            }
        }
    }
}
