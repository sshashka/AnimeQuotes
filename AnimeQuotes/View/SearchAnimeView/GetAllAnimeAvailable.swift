//
//  getAllAnimeAvailable.swift
//  AnimeQuotes
//
//  Created by Саша Василенко on 09.09.2022.
//

import UIKit

class GetAllAnimeAvailable: UIViewController {
    
    var presenter: AllAnimeAvailablePresenterProtocol!
    private var filteredData = [String]()
    private var isShowingSearchResults = false
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    private lazy var dataSource = UITableViewDiffableDataSource<Section, String> (
        tableView: tableView,
        cellProvider: {(tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: GetAllAvailableAnineCell.identifier, for: indexPath) as? GetAllAvailableAnineCell
            if let cell = cell {
                cell.nameLabel.text = item
            }
            return cell
        }
    )
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search anime name"
        searchController.searchBar.layer.masksToBounds = true
        searchController.searchBar.layer.cornerRadius = 8.0
        return searchController
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GetAllAvailableAnineCell.self, forCellReuseIdentifier: GetAllAvailableAnineCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        view.backgroundColor = .systemGroupedBackground
        setupSearchBarController()
        snapshot.appendSections([.main])
        presenter.getData()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if snapshot.numberOfItems != 0 {
            snapshot.deleteAllItems()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func setupSearchBarController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension GetAllAnimeAvailable: AllAnimeAvailableViewProtocol {
        
    func getSomeGoodStuff() {
        snapshot.appendItems(presenter.data!, toSection: .main)
        dataSource.apply(snapshot)
    }

}

extension GetAllAnimeAvailable: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        isShowingSearchResults = true
        guard let text = searchController.searchBar.text else { return }
        filteredData = presenter.data!.filter { str in
            str.contains(text)
        }
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredData)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if !searchController.isActive {
            getSomeGoodStuff()
            isShowingSearchResults = false
        }
    }
}

extension GetAllAnimeAvailable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch isShowingSearchResults {
        case true:
            let title = presenter.data!.firstIndex(of: filteredData[indexPath.row])!
            presenter.selectedAnimeTitle(title: presenter.data![title])
        case false:
            presenter.selectedAnimeTitle(title: presenter.data![indexPath.row])
        }
        navigationController?.tabBarController?.selectedIndex = 2
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


