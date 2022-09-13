import UIKit
import Lottie

class RandomQuotesViewController: UIViewController {
    
    var presenter: RandomQuotesModulePresenterProtocol!
    
    private var animationView: AnimationView?
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RandomQuotesCell.self, forCellReuseIdentifier: RandomQuotesCell.identifier)
        return tableView
    }()
    
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        tableView.delegate = self
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnimationView()
    }
    
    private func setupAnimationView() {
        animationView = .init(name: "67259-manheraresize")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.5
        animationView!.backgroundColor = .systemGroupedBackground
        view.addSubview(animationView!)
        animationView!.play()
        var secondsToPlayAnimation = 1.5
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            if secondsToPlayAnimation > 0 {
                secondsToPlayAnimation -= 0.1
            } else {
                self?.animationView!.stop()
                self?.animationView!.removeFromSuperview()
                timer.invalidate()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        presenter.getData()
    }
    deinit {
        print("deinit")
    }
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, Model>(
        tableView: tableView,
        cellProvider: {
            (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RandomQuotesCell.identifier,
                for: indexPath
            ) as? RandomQuotesCell
            
            cell?.quoteTextLabel.text = "Quote: " + item.quote
            cell?.heroNameTextLabel.text = "Character: " + item.character
            cell?.titleNameTextLabel.text = "Anime: " + item.anime
            return cell
        }
    )
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    
    private func shareFunctionSelected(data: Model) {
        let quote = "Anime: " + data.anime + "\n" + "\n" + "Character: " + data.character + "\n" + "\n" + "Quote: " + data.quote + "\n" + "\n" + "Sent with AnimeQuotesApp by sshashka"
        let activityVC = UIActivityViewController(activityItems: [quote], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func saveFunctionSelected(index: Int) {
        presenter.saveData(at: index)
    }
}

extension RandomQuotesViewController: RandomQuotesViewPresenterProtocol {
    
    func showSomeGoodStuff() {
        if snapshot.numberOfItems != 0 {
            snapshot.deleteAllItems()
        }
        guard let data = presenter.data else { return }
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
}

extension RandomQuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: nil) { [ weak self] action, view, completionHandler in
            guard let strongSelf = self else { return }
            let selectedQuote = strongSelf.presenter.data![indexPath.row]
            strongSelf.shareFunctionSelected(data: selectedQuote)
            completionHandler(true)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .systemOrange
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] action, view, completionHandler in
            guard let strongSelf = self else { return }
            strongSelf.saveFunctionSelected(index: indexPath.row)
            completionHandler(true)
        }
        saveAction.image = UIImage(systemName: "square.and.arrow.down")
        return UISwipeActionsConfiguration(actions: [saveAction])
    }
}


